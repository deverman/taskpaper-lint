import Foundation

/// Represents the source of input for the CLI
enum InputSource {
    case file(path: String)
    case stdin

    /// Read the content from the input source
    func readContent() throws -> String {
        switch self {
        case .file(let path):
            do {
                return try String(contentsOfFile: path, encoding: .utf8)
            } catch {
                throw CLIError.fileReadError(path: path, error: error)
            }
        case .stdin:
            var input = ""
            while let line = readLine() {
                input += line + "\n"
            }
            if input.isEmpty {
                throw CLIError.emptyInput
            }
            return input
        }
    }

    /// Get a display name for the input source
    var displayName: String {
        switch self {
        case .file(let path):
            return path
        case .stdin:
            return "<stdin>"
        }
    }
}
