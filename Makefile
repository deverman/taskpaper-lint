.PHONY: build clean test install release help

# Default target
help:
	@echo "Available targets:"
	@echo "  make build     - Build the project in debug mode"
	@echo "  make release   - Build the project in release mode"
	@echo "  make test      - Run tests"
	@echo "  make install   - Install to /usr/local/bin"
	@echo "  make clean     - Clean build artifacts"
	@echo "  make help      - Show this help message"

# Build in debug mode
build:
	swift build

# Build in release mode
release:
	swift build -c release

# Run tests
test:
	swift test

# Clean build artifacts
clean:
	swift package clean
	rm -rf .build

# Install to /usr/local/bin
install: release
	@echo "Installing taskpaper-lint to /usr/local/bin"
	@install -d /usr/local/bin
	@install .build/release/taskpaper-lint /usr/local/bin/taskpaper-lint
	@echo "Installation complete!"
	@echo "Run 'taskpaper-lint --help' to get started"

# Install to user's home bin directory
install-local: release
	@echo "Installing taskpaper-lint to ~/bin"
	@mkdir -p ~/bin
	@install .build/release/taskpaper-lint ~/bin/taskpaper-lint
	@echo "Installation complete!"
	@echo "Make sure ~/bin is in your PATH"
	@echo "Run 'taskpaper-lint --help' to get started"

# Update dependencies
update:
	swift package update

# Resolve dependencies
resolve:
	swift package resolve

# Run in debug mode with example file
run-example: build
	.build/debug/taskpaper-lint validate examples/sample.taskpaper --verbose

# Generate and open documentation
docs:
	swift package generate-documentation
