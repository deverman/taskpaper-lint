import Foundation
import TaskPaper

/// Output format options
enum OutputFormat: String, ExpressibleByArgument {
    case json
    case pretty
    case tree

    var description: String {
        switch self {
        case .json:
            return "JSON representation"
        case .pretty:
            return "Human-readable formatted output"
        case .tree:
            return "Tree-style visualization"
        }
    }
}

/// Protocol for formatting TaskPaper documents
protocol Formatter {
    func format(_ document: TaskPaperDocument) -> String
}

/// JSON formatter
struct JSONFormatter: Formatter {
    func format(_ document: TaskPaperDocument) -> String {
        let items = formatItems(document.items)

        do {
            let jsonData = try JSONSerialization.data(
                withJSONObject: ["items": items],
                options: [.prettyPrinted, .sortedKeys]
            )
            return String(data: jsonData, encoding: .utf8) ?? "{}"
        } catch {
            return "{\"error\": \"Failed to serialize JSON\"}"
        }
    }

    private func formatItems(_ items: [TaskPaperItem]) -> [[String: Any]] {
        items.map { item in
            var dict: [String: Any] = [
                "type": item.type.rawValue,
                "content": item.content
            ]

            if !item.attributes.isEmpty {
                dict["attributes"] = item.attributes.mapValues { $0 ?? NSNull() }
            }

            if !item.children.isEmpty {
                dict["children"] = formatItems(item.children)
            }

            return dict
        }
    }
}

/// Pretty formatter (human-readable)
struct PrettyFormatter: Formatter {
    func format(_ document: TaskPaperDocument) -> String {
        var output = ""
        formatItems(document.items, indent: 0, output: &output)
        return output
    }

    private func formatItems(_ items: [TaskPaperItem], indent: Int, output: inout String) {
        for item in items {
            let indentStr = String(repeating: "  ", count: indent)

            switch item.type {
            case .project:
                output += "\(indentStr)📁 PROJECT: \(item.content)\n"
            case .task:
                output += "\(indentStr)☐ TASK: \(item.content)\n"
            case .note:
                output += "\(indentStr)📝 NOTE: \(item.content)\n"
            }

            if !item.attributes.isEmpty {
                for (key, value) in item.attributes.sorted(by: { $0.key < $1.key }) {
                    let valueStr = value ?? "(no value)"
                    output += "\(indentStr)  @\(key): \(valueStr)\n"
                }
            }

            if !item.children.isEmpty {
                formatItems(item.children, indent: indent + 1, output: &output)
            }
        }
    }
}

/// Tree formatter (tree-style visualization)
struct TreeFormatter: Formatter {
    func format(_ document: TaskPaperDocument) -> String {
        var output = ".\n"
        formatItems(document.items, prefix: "", isLast: true, output: &output)
        return output
    }

    private func formatItems(_ items: [TaskPaperItem], prefix: String, isLast: Bool, output: inout String) {
        for (index, item) in items.enumerated() {
            let isLastItem = index == items.count - 1
            let connector = isLastItem ? "└── " : "├── "
            let icon: String

            switch item.type {
            case .project:
                icon = "📁"
            case .task:
                icon = "☐"
            case .note:
                icon = "📝"
            }

            output += "\(prefix)\(connector)\(icon) \(item.content)"

            if !item.attributes.isEmpty {
                let attrs = item.attributes.map { key, value in
                    if let value = value {
                        return "@\(key)(\(value))"
                    } else {
                        return "@\(key)"
                    }
                }.joined(separator: " ")
                output += " [\(attrs)]"
            }

            output += "\n"

            if !item.children.isEmpty {
                let newPrefix = prefix + (isLastItem ? "    " : "│   ")
                formatItems(item.children, prefix: newPrefix, isLast: isLastItem, output: &output)
            }
        }
    }
}

/// Factory for creating formatters
struct FormatterFactory {
    static func create(for format: OutputFormat) -> Formatter {
        switch format {
        case .json:
            return JSONFormatter()
        case .pretty:
            return PrettyFormatter()
        case .tree:
            return TreeFormatter()
        }
    }
}
