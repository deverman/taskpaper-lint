# taskpaper-lint

A command-line tool for linting, validating, and parsing TaskPaper files. Built with Swift and powered by the modernized TaskPaper library.

## Features

- **Validate** TaskPaper files for syntax errors
- **Parse** TaskPaper files with multiple output formats
- **Stdin support** for piping content
- **Detailed error reporting** with line numbers
- **Multiple output formats**: JSON, pretty-print, and tree visualization

## Requirements

- Swift 6.0+
- macOS 13.0+ (Linux support may be available depending on TaskPaper library)

## Installation

### Building from Source

1. Clone the repository:
```bash
git clone https://github.com/deverman/taskpaper-lint.git
cd taskpaper-lint
```

2. Build the project:
```bash
swift build -c release
```

3. The executable will be located at `.build/release/taskpaper-lint`

### Installing Locally

You can copy the built executable to your local bin directory:

```bash
# Build in release mode
swift build -c release

# Copy to local bin (make sure ~/bin or /usr/local/bin is in your PATH)
cp .build/release/taskpaper-lint /usr/local/bin/

# Or to your home directory bin
mkdir -p ~/bin
cp .build/release/taskpaper-lint ~/bin/
```

### Using Swift Package Manager

You can also run directly using Swift:

```bash
swift run taskpaper-lint validate myfile.taskpaper
```

## Usage

### Validate Command

Check if a TaskPaper file is syntactically valid:

```bash
# Validate a file
taskpaper-lint validate myfile.taskpaper

# Validate with verbose output (shows statistics)
taskpaper-lint validate myfile.taskpaper --verbose

# Validate from stdin
cat myfile.taskpaper | taskpaper-lint validate
echo "My Project:" | taskpaper-lint validate
```

**Exit codes:**
- `0`: File is valid
- `1`: File has syntax errors or other errors

**Example output:**
```
✅ myfile.taskpaper is valid

Document statistics:
  Total items: 15
  Projects: 3
  Tasks: 10
  Notes: 2
```

### Parse Command

Parse and output the structure of a TaskPaper file:

```bash
# Parse with default (pretty) format
taskpaper-lint parse myfile.taskpaper

# Parse with JSON format
taskpaper-lint parse myfile.taskpaper --format json

# Parse with tree format
taskpaper-lint parse myfile.taskpaper --format tree

# Parse from stdin
cat myfile.taskpaper | taskpaper-lint parse --format json
```

**Available formats:**

1. **json** - JSON representation of the parsed structure
   ```json
   {
     "items": [
       {
         "type": "project",
         "content": "My Project",
         "attributes": {},
         "children": [...]
       }
     ]
   }
   ```

2. **pretty** - Human-readable formatted output
   ```
   📁 PROJECT: My Project
     ☐ TASK: First task
       @priority: high
     ☐ TASK: Second task
     📝 NOTE: Some note
   ```

3. **tree** - Tree-style visualization
   ```
   .
   ├── 📁 My Project
   │   ├── ☐ First task [@priority(high)]
   │   ├── ☐ Second task
   │   └── 📝 Some note
   ```

### General Options

```bash
# Show help
taskpaper-lint --help

# Show version
taskpaper-lint --version

# Show help for a specific command
taskpaper-lint validate --help
taskpaper-lint parse --help
```

## Examples

### Basic Validation

```bash
# Create a sample file
cat > sample.taskpaper << 'EOF'
My Project:
    - Task 1 @priority(high)
    - Task 2 @done
    Note about the project
EOF

# Validate it
taskpaper-lint validate sample.taskpaper --verbose
```

### Parse to JSON

```bash
# Parse and save JSON output
taskpaper-lint parse sample.taskpaper --format json > output.json

# Parse from stdin
echo "Quick Project:\n\t- Quick task" | taskpaper-lint parse --format tree
```

### Error Detection

```bash
# Create an invalid file (if TaskPaper has specific syntax rules)
echo "Invalid syntax here" > invalid.taskpaper

# Validate will report errors
taskpaper-lint validate invalid.taskpaper
# Output:
# ❌ Validation failed for invalid.taskpaper
# Parse error: [error message]
#   at line 1
```

## Development

### Running Tests

```bash
swift test
```

### Project Structure

```
taskpaper-lint/
├── Package.swift                      # Swift package manifest
├── Sources/
│   └── taskpaper-lint/
│       ├── main.swift                 # Main entry point
│       ├── ValidateCommand.swift      # Validate command
│       ├── ParseCommand.swift         # Parse command
│       ├── OutputFormatter.swift      # Output formatters
│       ├── InputSource.swift          # Input handling
│       └── CLIError.swift             # Error definitions
└── Tests/
    └── taskpaper-lint-tests/
        └── TaskPaperLintTests.swift   # Unit tests
```

### Dependencies

- [Swift Argument Parser](https://github.com/apple/swift-argument-parser) - Command-line argument parsing
- [TaskPaper](https://github.com/deverman/TaskPaper.git) - TaskPaper parsing library

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Related Projects

- [TaskPaper](https://github.com/deverman/TaskPaper.git) - The modernized TaskPaper Swift library
- [TaskPaper Format](https://www.taskpaper.com) - Original TaskPaper application and format

## Troubleshooting

### Build Errors

If you encounter build errors related to the TaskPaper dependency:

1. Ensure you have Swift 6.0+ installed:
   ```bash
   swift --version
   ```

2. Clean and rebuild:
   ```bash
   swift package clean
   swift build
   ```

3. Update dependencies:
   ```bash
   swift package update
   ```

### Runtime Errors

If the tool fails to read files:
- Check file permissions: `ls -la yourfile.taskpaper`
- Ensure the file exists and path is correct
- Try using absolute paths instead of relative paths

For stdin issues:
- Ensure you're piping valid UTF-8 text
- Check that the input is not empty

## Support

For issues and feature requests, please use the [GitHub issue tracker](https://github.com/deverman/taskpaper-lint/issues).
