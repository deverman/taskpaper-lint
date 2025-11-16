import Foundation

// Extension to print to stderr
extension FileHandle: @retroactive TextOutputStream {
    public func write(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.write(data)
        }
    }
}

// Helper function to print to stderr (avoiding inout parameter issues)
func printErr(_ message: String) {
    var stderr = FileHandle.standardError
    print(message, to: &stderr)
}
