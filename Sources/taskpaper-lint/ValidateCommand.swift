import ArgumentParser
import Foundation
import TaskPaper

struct Validate: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Validate a TaskPaper file for syntax errors"
    )

    @Argument(help: "Path to the TaskPaper file to validate (or omit to read from stdin)")
    var filePath: String?

    @Flag(name: .shortAndLong, help: "Show detailed validation information")
    var verbose: Bool = false

    func run() throws {
        let inputSource: InputSource = if let path = filePath {
            .file(path: path)
        } else {
            .stdin
        }

        // Read the content
        let content: String
        do {
            content = try inputSource.readContent()
        } catch {
            print("Error: \(error.localizedDescription)", to: &stderr)
            throw ExitCode.failure
        }

        // Parse the document
        let parser = TaskPaperParser()
        let document: TaskPaperDocument

        do {
            document = try parser.parse(content)
        } catch let error as TaskPaperParseError {
            print("❌ Validation failed for \(inputSource.displayName)", to: &stderr)
            print("", to: &stderr)
            print("Parse error: \(error.localizedDescription)", to: &stderr)

            if let line = error.line {
                print("  at line \(line)", to: &stderr)
            }

            if verbose, let context = error.context {
                print("", to: &stderr)
                print("Context:", to: &stderr)
                print("  \(context)", to: &stderr)
            }

            throw ExitCode.failure
        } catch {
            print("❌ Validation failed for \(inputSource.displayName)", to: &stderr)
            print("", to: &stderr)
            print("Unexpected error: \(error.localizedDescription)", to: &stderr)
            throw ExitCode.failure
        }

        // If we got here, validation succeeded
        print("✅ \(inputSource.displayName) is valid")

        if verbose {
            let itemCount = countItems(document.items)
            let projectCount = countItemsOfType(document.items, type: .project)
            let taskCount = countItemsOfType(document.items, type: .task)
            let noteCount = countItemsOfType(document.items, type: .note)

            print("")
            print("Document statistics:")
            print("  Total items: \(itemCount)")
            print("  Projects: \(projectCount)")
            print("  Tasks: \(taskCount)")
            print("  Notes: \(noteCount)")
        }
    }

    private func countItems(_ items: [TaskPaperItem]) -> Int {
        var count = items.count
        for item in items {
            count += countItems(item.children)
        }
        return count
    }

    private func countItemsOfType(_ items: [TaskPaperItem], type: TaskPaperItemType) -> Int {
        var count = items.filter { $0.type == type }.count
        for item in items {
            count += countItemsOfType(item.children, type: type)
        }
        return count
    }
}

// Extension to print to stderr
extension FileHandle: TextOutputStream {
    public func write(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.write(data)
        }
    }
}

var stderr = FileHandle.standardError
