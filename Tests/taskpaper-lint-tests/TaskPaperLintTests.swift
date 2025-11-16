import XCTest
@testable import taskpaper_lint

final class TaskPaperLintTests: XCTestCase {
    func testInputSourceFile() throws {
        // Create a temporary file
        let tempDir = FileManager.default.temporaryDirectory
        let tempFile = tempDir.appendingPathComponent("test.taskpaper")
        let content = "Test Project:\n\t- Test task @tag\n"

        try content.write(to: tempFile, atomically: true, encoding: .utf8)
        defer { try? FileManager.default.removeItem(at: tempFile) }

        let source = InputSource.file(path: tempFile.path)
        let readContent = try source.readContent()

        XCTAssertEqual(readContent, content)
        XCTAssertEqual(source.displayName, tempFile.path)
    }

    func testJSONFormatter() throws {
        // This is a placeholder test - actual implementation would depend on TaskPaper library
        // For now, just verify the formatter can be created
        let formatter = FormatterFactory.create(for: .json)
        XCTAssertTrue(formatter is JSONFormatter)
    }

    func testPrettyFormatter() throws {
        let formatter = FormatterFactory.create(for: .pretty)
        XCTAssertTrue(formatter is PrettyFormatter)
    }

    func testTreeFormatter() throws {
        let formatter = FormatterFactory.create(for: .tree)
        XCTAssertTrue(formatter is TreeFormatter)
    }

    func testOutputFormatFromString() {
        XCTAssertEqual(OutputFormat(rawValue: "json"), .json)
        XCTAssertEqual(OutputFormat(rawValue: "pretty"), .pretty)
        XCTAssertEqual(OutputFormat(rawValue: "tree"), .tree)
        XCTAssertNil(OutputFormat(rawValue: "invalid"))
    }

    func testCLIErrorDescriptions() {
        let fileError = CLIError.fileReadError(path: "/test/file.txt", error: NSError(domain: "test", code: 1))
        XCTAssertNotNil(fileError.errorDescription)

        let emptyInputError = CLIError.emptyInput
        XCTAssertEqual(emptyInputError.errorDescription, "No input provided")

        let parseError = CLIError.parseError(message: "Invalid syntax", line: 5)
        XCTAssertTrue(parseError.errorDescription?.contains("line 5") ?? false)

        let formatError = CLIError.invalidFormat(format: "yaml")
        XCTAssertTrue(formatError.errorDescription?.contains("yaml") ?? false)
    }
}
