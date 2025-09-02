#!/bin/bash

set -e

echo "🚀 Running post-create setup for VizVault..."

# Ensure Go tools are in PATH
export PATH="/usr/local/go/bin:/go/bin:${PATH}"

# Initialize Go module if it doesn't exist
if [ ! -f "go.mod" ]; then
    echo "📦 Initializing Go module..."
    go mod init github.com/$(whoami)/vizvault
fi

# Download Go dependencies
echo "📥 Downloading Go dependencies..."
go mod download
go mod tidy

# Verify Go installation
echo "🔍 Verifying Go installation..."
go version

# Verify GoReleaser installation
echo "🔍 Verifying GoReleaser installation..."
if command -v goreleaser &> /dev/null; then
    goreleaser --version
else
    echo "⚠️  GoReleaser not found - installing..."
    go install github.com/goreleaser/goreleaser/v2@latest
fi

# Verify Claude Code CLI installation
echo "🔍 Verifying Claude Code CLI installation..."
if command -v claude &> /dev/null; then
    claude --version
else
    echo "⚠️  Claude CLI not found - manual installation may be required"
fi

# Set up Git configuration
echo "⚙️  Setting up Git configuration..."
# Copy host gitconfig if available
if [ -f /tmp/.gitconfig ]; then
    cp /tmp/.gitconfig ~/.gitconfig
fi
# Set default values if not already configured
git config --global init.defaultBranch main 2>/dev/null || true
git config --global pull.rebase false 2>/dev/null || true

# Create basic project directories if they don't exist
echo "📁 Creating project structure..."
mkdir -p cmd/vizvault
mkdir -p internal
mkdir -p pkg
mkdir -p docs
mkdir -p scripts
mkdir -p .github/workflows

# Ensure all Go tools are properly installed
echo "🔧 Verifying Go development tools..."
command -v gopls &> /dev/null || echo "  ⚠️  gopls not found"
command -v dlv &> /dev/null || echo "  ⚠️  dlv not found"
command -v staticcheck &> /dev/null || echo "  ⚠️  staticcheck not found"
command -v goimports &> /dev/null || echo "  ⚠️  goimports not found"
command -v golangci-lint &> /dev/null || echo "  ⚠️  golangci-lint not found"

echo "✅ Post-create setup completed successfully!"
echo ""
echo "🎯 Next steps:"
echo "  - Open the project in your preferred IDE (VS Code or GoLand)"
echo "  - Start developing with 'make dev' or 'go run cmd/vizvault/main.go'"
echo "  - Run tests with 'make test'"
echo "  - Build release with 'make build' or 'goreleaser build --snapshot'"
echo "  - Enable git hooks with 'pre-commit install' (already installed)"
