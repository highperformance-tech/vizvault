.PHONY: help build test clean dev lint fmt vet run release snapshot docker-build

# Variables
BINARY_NAME=vizvault
MAIN_PATH=./cmd/vizvault
VERSION?=$(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
COMMIT?=$(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
DATE?=$(shell date -u +'%Y-%m-%dT%H:%M:%SZ')

# Build flags
LDFLAGS=-ldflags "-s -w -X main.version=$(VERSION) -X main.commit=$(COMMIT) -X main.date=$(DATE)"
BUILD_FLAGS=-trimpath $(LDFLAGS)

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@egrep '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Build the binary
	@echo "Building $(BINARY_NAME)..."
	@CGO_ENABLED=0 go build -buildvcs=false $(BUILD_FLAGS) -o bin/$(BINARY_NAME) $(MAIN_PATH)

test: ## Run tests
	@echo "Running tests..."
	@go test -v ./...

test-coverage: ## Run tests with coverage
	@echo "Running tests with coverage..."
	@go test -v -coverprofile=coverage.out ./...
	@go tool cover -html=coverage.out -o coverage.html

clean: ## Clean build artifacts
	@echo "Cleaning..."
	@rm -rf bin/ dist/ coverage.out coverage.html

dev: ## Run in development mode with hot reload
	@echo "Starting development server..."
	@go run $(MAIN_PATH)

lint: ## Run golangci-lint
	@echo "Running linter..."
	@golangci-lint run

fmt: ## Format code
	@echo "Formatting code..."
	@go fmt ./...
	@goimports -w .

vet: ## Run go vet
	@echo "Running go vet..."
	@go vet ./...

run: build ## Build and run the binary
	@echo "Running $(BINARY_NAME)..."
	@./bin/$(BINARY_NAME)

deps: ## Download dependencies
	@echo "Downloading dependencies..."
	@go mod download
	@go mod tidy

release: ## Create a release build using goreleaser
	@echo "Creating release..."
	@goreleaser release --clean

snapshot: ## Create a snapshot build using goreleaser
	@echo "Creating snapshot build..."
	@goreleaser build --snapshot --clean

docker-build: ## Build Docker image
	@echo "Building Docker image..."
	@docker build -t $(BINARY_NAME):$(VERSION) .

install-tools: ## Install development tools
	@echo "Installing development tools..."
	@go install golang.org/x/tools/cmd/goimports@latest
	@go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.4.0
	@go install honnef.co/go/tools/cmd/staticcheck@latest
	@go install golang.org/x/vuln/cmd/govulncheck@latest
	@go install github.com/securego/gosec/v2/cmd/gosec@latest

fmt-check: ## Check formatting (no changes)
	@echo "Checking formatting..."
	@test -z "$$(gofmt -l .)" || (echo "Files need formatting:"; gofmt -l .; exit 1)

security: ## Run security checks
	@echo "Running security checks..."
	@govulncheck ./...
	@gosec -fmt json ./...
	@echo "Security checks completed"

security-scan: ## Run comprehensive security scanning including container
	@echo "Running comprehensive security scan..."
	@govulncheck ./...
	@gosec ./...
	@docker build -t vizvault:scan .
	@docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
		aquasec/trivy image vizvault:scan
	@echo "Security scanning completed"

pre-commit-install: ## Install pre-commit hooks
	@echo "Installing pre-commit hooks..."
	@pre-commit install
	@echo "Pre-commit hooks installed"

pre-commit-run: ## Run pre-commit hooks on all files
	@echo "Running pre-commit hooks..."
	@pre-commit run --all-files

docker-build-prod: ## Build production Docker image
	@echo "Building production Docker image..."
	@docker build -t $(BINARY_NAME):$(VERSION) .

docker-scan: ## Scan Docker image for vulnerabilities
	@echo "Scanning Docker image..."
	@docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
		aquasec/trivy image $(BINARY_NAME):$(VERSION)

# TODO: Install Air for hot reload in dev target
# air can be installed with: go install github.com/air-verse/air@latest
# Then update dev target to use: air

# Default target
all: fmt vet lint test build
