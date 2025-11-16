import ArgumentParser
import Foundation
import TaskPaper

struct Parse: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Parse a TaskPaper file and output its structure"
    )

    @Argument(help: "Path to the TaskPaper file to parse (or omit to read from stdin)")
    var filePath: String?

    @Option(name: .shortAndLong, help: "Output format: json, pretty, or tree")
    var format: OutputFormat = .pretty

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

        // Format and output the result
        let formatter = FormatterFactory.create(for: format)
        let output = formatter.format(document, source: content as NSString)
        print(output)
    }
}
