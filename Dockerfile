# Build stage
FROM golang:1.25-bookworm AS builder

WORKDIR /build

# Copy go mod files
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build the binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -buildvcs=false \
    -ldflags="-w -s -extldflags '-static'" \
    -a -installsuffix cgo \
    -o vizvault \
    ./cmd/vizvault

# Run stage - using distroless for minimal attack surface
FROM gcr.io/distroless/static-debian12:nonroot

# Copy the binary from builder
COPY --from=builder /build/vizvault /vizvault

# Use nonroot user (65532)
USER nonroot:nonroot

# Expose default ports
EXPOSE 8080 8443

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD ["/vizvault", "health"]

# Run the binary
ENTRYPOINT ["/vizvault"]
