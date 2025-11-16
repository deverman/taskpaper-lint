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
            printErr("Error: \(error.localizedDescription)")
            throw ExitCode.failure
        }

        // Parse the document (TaskPaper parser doesn't throw errors)
        let document = TaskPaper(content)

        // If we got here, validation succeeded (TaskPaper always parses successfully)
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

    private func countItems(_ items: [Item]) -> Int {
        var count = items.count
        for item in items {
            count += countItems(item.children)
        }
        return count
    }

    private func countItemsOfType(_ items: [Item], type: Item.ItemType) -> Int {
        var count = items.filter { $0.type == type }.count
        for item in items {
            count += countItemsOfType(item.children, type: type)
        }
        return count
    }
}
