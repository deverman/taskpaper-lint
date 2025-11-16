import Foundation

/// Custom errors for the CLI tool
enum CLIError: LocalizedError {
    case fileReadError(path: String, error: Error)
    case emptyInput
    case parseError(message: String, line: Int? = nil)
    case invalidFormat(format: String)

    var errorDescription: String? {
        switch self {
        case .fileReadError(let path, let error):
            return "Failed to read file '\(path)': \(error.localizedDescription)"
        case .emptyInput:
            return "No input provided"
        case .parseError(let message, let line):
            if let line = line {
                return "Parse error at line \(line): \(message)"
            } else {
                return "Parse error: \(message)"
            }
        case .invalidFormat(let format):
            return "Invalid format '\(format)'. Valid formats are: json, pretty, tree"
        }
    }
}
