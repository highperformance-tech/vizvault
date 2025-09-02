# VizVault

A high-performance visualization and data management platform built with Go.

## Development Setup

This project includes a complete devcontainer setup for consistent development environments across team members.

### Prerequisites

- [Docker](https://www.docker.com/get-started)
- One of the following IDEs:
  - [VS Code](https://code.visualstudio.com/) with [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
  - [JetBrains GoLand](https://www.jetbrains.com/go/) with [JetBrains Gateway](https://www.jetbrains.com/remote-development/gateway/)

### Getting Started with VS Code

1. Clone this repository
2. Open the project in VS Code
3. When prompted, click "Reopen in Container" (or use Command Palette: "Dev Containers: Reopen in Container")
4. Wait for the container to build and the post-create script to run
5. Start developing!

### Getting Started with JetBrains GoLand

1. Open GoLand
2. Go to File → Remote Development → WSL/SSH/Docker
3. Configure Docker connection
4. Select the devcontainer configuration
5. GoLand will build and connect to the container

### Development Environment Includes

- **Go 1.25** - Latest Go version
- **GoReleaser** - For building and releasing binaries
- **Claude Code CLI** - AI-powered development assistance
- **Development Tools**:
  - `gopls` - Go language server
  - `golangci-lint` - Go linter
  - `delve` - Go debugger
  - `goimports` - Import management
  - `staticcheck` - Static analysis

### Available Commands

```bash
# Development
make dev          # Run in development mode
make build        # Build binary
make run          # Build and run
make test         # Run tests
make test-coverage # Run tests with coverage

# Code Quality
make fmt          # Format code
make lint         # Run linter
make vet          # Run go vet

# Release
make release      # Create release with goreleaser
make snapshot     # Create snapshot build

# Utilities
make clean        # Clean build artifacts
make deps         # Download dependencies
make help         # Show all available commands
```

### Project Structure

```
vizvault/
├── .devcontainer/          # Development container configuration
│   ├── devcontainer.json   # Container and IDE settings
│   ├── Dockerfile          # Container image definition
│   └── post-create.sh      # Post-creation setup script
├── .github/workflows/      # GitHub Actions workflows
├── cmd/vizvault/          # Application entrypoint
├── internal/              # Private application code
├── pkg/                   # Public library code
├── docs/                  # Documentation
└── scripts/               # Build and deployment scripts
```

### Environment Variables

The devcontainer automatically sets up the following environment variables:

- `GOPATH=/go`
- `GOROOT=/usr/local/go`
- `CGO_ENABLED=0`

### Contributing

1. Create a feature branch
2. Make your changes
3. Run tests: `make test`
4. Run linting: `make lint`
5. Build the project: `make build`
6. Submit a pull request

### IDE Features

#### VS Code Extensions (Auto-installed)
- Go language support
- YAML support for configurations
- Makefile support
- GitHub integration

#### JetBrains GoLand Plugins (Auto-installed)
- YAML support
- Docker integration
- Makefile support
- GitHub Copilot (if available)

### Troubleshooting

#### Container Build Issues
- Ensure Docker is running
- Check Docker has sufficient memory allocated (4GB+ recommended)
- Try rebuilding the container: "Dev Containers: Rebuild Container"

#### Go Module Issues
- The post-create script automatically runs `go mod download` and `go mod tidy`
- If you encounter module issues, run `make deps`

#### Tool Installation Issues
- The container includes all necessary tools
- If tools are missing, run `make install-tools`

## License

[Add your license here]
