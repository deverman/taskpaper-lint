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
            print("Error: \(error.localizedDescription)", to: &stderr)
            throw ExitCode.failure
        }

        // Parse the document
        let parser = TaskPaperParser()
        let document: TaskPaperDocument

        do {
            document = try parser.parse(content)
        } catch let error as TaskPaperParseError {
            print("❌ Parse failed for \(inputSource.displayName)", to: &stderr)
            print("", to: &stderr)
            print("Parse error: \(error.localizedDescription)", to: &stderr)

            if let line = error.line {
                print("  at line \(line)", to: &stderr)
            }

            if let context = error.context {
                print("", to: &stderr)
                print("Context:", to: &stderr)
                print("  \(context)", to: &stderr)
            }

            throw ExitCode.failure
        } catch {
            print("❌ Parse failed for \(inputSource.displayName)", to: &stderr)
            print("", to: &stderr)
            print("Unexpected error: \(error.localizedDescription)", to: &stderr)
            throw ExitCode.failure
        }

        // Format and output the result
        let formatter = FormatterFactory.create(for: format)
        let output = formatter.format(document)
        print(output)
    }
}
