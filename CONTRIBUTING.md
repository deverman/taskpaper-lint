# Contributing to taskpaper-lint

Thank you for your interest in contributing to taskpaper-lint! This document provides guidelines for contributing to the project.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/taskpaper-lint.git`
3. Create a feature branch: `git checkout -b feature/my-new-feature`
4. Make your changes
5. Test your changes: `swift test`
6. Commit your changes: `git commit -am 'Add some feature'`
7. Push to the branch: `git push origin feature/my-new-feature`
8. Create a Pull Request

## Development Setup

### Requirements

- Swift 6.0 or later
- Xcode 15.0+ (for macOS development)
- Git

### Building

```bash
# Clone the repository
git clone https://github.com/deverman/taskpaper-lint.git
cd taskpaper-lint

# Fetch dependencies
swift package resolve

# Build the project
swift build

# Run tests
swift test
```

## Code Style

- Follow Swift API Design Guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions focused and concise
- Use Swift's modern concurrency features when appropriate

## Testing

All new features should include tests:

- Add unit tests in `Tests/taskpaper-lint-tests/`
- Ensure all tests pass before submitting a PR
- Aim for good test coverage

```bash
# Run all tests
swift test

# Run tests with verbose output
swift test --verbose
```

## Pull Request Guidelines

1. **One feature per PR**: Keep pull requests focused on a single feature or bug fix
2. **Update documentation**: Update README.md if you add new features
3. **Add tests**: Include tests for new functionality
4. **Follow code style**: Maintain consistency with existing code
5. **Write clear commit messages**: Use descriptive commit messages

### Commit Message Format

```
Add feature: Brief description

Longer description if needed explaining what changed and why.
```

Examples:
- `Add support for YAML output format`
- `Fix: Handle empty files gracefully`
- `Improve error messages for invalid syntax`

## Feature Requests

We welcome feature requests! Please:

1. Check if the feature has already been requested
2. Open an issue describing the feature
3. Explain the use case and benefits
4. Be open to discussion and feedback

## Bug Reports

When reporting bugs, please include:

1. A clear description of the issue
2. Steps to reproduce
3. Expected behavior
4. Actual behavior
5. Your environment (macOS version, Swift version, etc.)
6. Sample TaskPaper files if relevant

## Project Structure

```
taskpaper-lint/
├── Sources/taskpaper-lint/    # Main source code
│   ├── main.swift             # Entry point
│   ├── ValidateCommand.swift  # Validate command
│   ├── ParseCommand.swift     # Parse command
│   ├── OutputFormatter.swift  # Formatters
│   ├── InputSource.swift      # Input handling
│   └── CLIError.swift         # Error types
├── Tests/                     # Test files
├── examples/                  # Example TaskPaper files
└── Package.swift              # Package manifest
```

## Adding New Commands

To add a new command:

1. Create a new file in `Sources/taskpaper-lint/` (e.g., `MyCommand.swift`)
2. Implement the `ParsableCommand` protocol
3. Add the command to `TaskPaperLint.configuration.subcommands` in `main.swift`
4. Add tests for the new command
5. Update README.md with usage examples

Example:

```swift
import ArgumentParser
import TaskPaper

struct MyCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Description of my command"
    )

    @Argument(help: "Input file")
    var filePath: String?

    func run() throws {
        // Implementation
    }
}
```

## Adding New Output Formats

To add a new output format:

1. Add the format to the `OutputFormat` enum in `OutputFormatter.swift`
2. Create a new formatter struct implementing the `Formatter` protocol
3. Update `FormatterFactory.create(for:)` to handle the new format
4. Add tests for the new formatter
5. Update README.md documentation

## Questions?

If you have questions about contributing, feel free to:

- Open an issue for discussion
- Reach out to the maintainers

## Code of Conduct

Be respectful and constructive in all interactions. We want this to be a welcoming community for everyone.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
