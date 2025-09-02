FROM golang:1.25-bookworm

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Install system dependencies and pre-commit
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        git \
        curl \
        wget \
        ca-certificates \
        build-essential \
        ssh \
        sudo \
        vim \
        nano \
        jq \
        unzip \
        tar \
        python3 \
        python3-pip \
        python3-venv \
    && pip3 install --no-cache-dir --break-system-packages pre-commit \
    && rm -rf /var/lib/apt/lists/*

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Install GoReleaser
RUN echo 'deb [trusted=yes] https://repo.goreleaser.com/apt/ /' | tee /etc/apt/sources.list.d/goreleaser.list \
    && apt-get update \
    && apt-get install -y goreleaser \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm for Claude Code CLI
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code CLI via npm
RUN npm install -g @anthropic-ai/claude-code

# Install additional Go tools with pinned versions
RUN go install golang.org/x/tools/gopls@v0.20.0 \
    && go install github.com/go-delve/delve/cmd/dlv@v1.25.1 \
    && go install honnef.co/go/tools/cmd/staticcheck@2025.1.1 \
    && go install golang.org/x/tools/cmd/goimports@v0.34.0 \
    && go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.4.0 \
    && go install golang.org/x/vuln/cmd/govulncheck@latest \
    && go install github.com/securego/gosec/v2/cmd/gosec@v2.22.7 \
    && curl -sSfL https://raw.githubusercontent.com/gitleaks/gitleaks/master/install.sh | sh -s -- -b /usr/local/bin v8.28.0

# Set up Go environment
ENV GOPATH=/go
ENV GOROOT=/usr/local/go
ENV PATH="${GOROOT}/bin:${GOPATH}/bin:${PATH}"
ENV CGO_ENABLED=0

# Create workspace directory
RUN mkdir -p /workspace && chown -R $USERNAME:$USERNAME /workspace
RUN mkdir -p /go && chown -R $USERNAME:$USERNAME /go

# Switch to non-root user
USER $USERNAME

WORKDIR /workspace
