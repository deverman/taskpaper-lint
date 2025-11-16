import ArgumentParser

struct TaskPaperLint: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "taskpaper-lint",
        abstract: "A command-line tool for linting and parsing TaskPaper files",
        version: "1.0.0",
        subcommands: [Validate.self, Parse.self],
        defaultSubcommand: Validate.self
    )
}

// Entry point
TaskPaperLint.main()
