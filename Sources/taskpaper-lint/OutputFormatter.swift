import Foundation
import ArgumentParser
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
    func format(_ document: TaskPaper, source: NSString) -> String
}

/// JSON formatter
struct JSONFormatter: Formatter {
    func format(_ document: TaskPaper, source: NSString) -> String {
        let items = formatItems(document.items, source: source)

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

    private func formatItems(_ items: [Item], source: NSString) -> [[String: Any]] {
        items.map { item in
            let content = source.substring(with: item.contentRange)
            var dict: [String: Any] = [
                "type": typeString(item.type),
                "content": content
            ]

            if !item.tags.isEmpty {
                var tags: [String: Any] = [:]
                for tag in item.tags {
                    tags[tag.name] = tag.value ?? NSNull()
                }
                dict["tags"] = tags
            }

            if !item.children.isEmpty {
                dict["children"] = formatItems(item.children, source: source)
            }

            return dict
        }
    }

    private func typeString(_ type: Item.ItemType) -> String {
        switch type {
        case .note: return "note"
        case .project: return "project"
        case .task: return "task"
        }
    }
}

/// Pretty formatter (human-readable)
struct PrettyFormatter: Formatter {
    func format(_ document: TaskPaper, source: NSString) -> String {
        var output = ""
        formatItems(document.items, source: source, indent: 0, output: &output)
        return output
    }

    private func formatItems(_ items: [Item], source: NSString, indent: Int, output: inout String) {
        for item in items {
            let indentStr = String(repeating: "  ", count: indent)
            let content = source.substring(with: item.contentRange)

            switch item.type {
            case .project:
                output += "\(indentStr)📁 PROJECT: \(content)\n"
            case .task:
                output += "\(indentStr)☐ TASK: \(content)\n"
            case .note:
                output += "\(indentStr)📝 NOTE: \(content)\n"
            }

            if !item.tags.isEmpty {
                for tag in item.tags.sorted(by: { $0.name < $1.name }) {
                    let valueStr = tag.value ?? "(no value)"
                    output += "\(indentStr)  @\(tag.name): \(valueStr)\n"
                }
            }

            if !item.children.isEmpty {
                formatItems(item.children, source: source, indent: indent + 1, output: &output)
            }
        }
    }
}

/// Tree formatter (tree-style visualization)
struct TreeFormatter: Formatter {
    func format(_ document: TaskPaper, source: NSString) -> String {
        var output = ".\n"
        formatItems(document.items, source: source, prefix: "", isLast: true, output: &output)
        return output
    }

    private func formatItems(_ items: [Item], source: NSString, prefix: String, isLast: Bool, output: inout String) {
        for (index, item) in items.enumerated() {
            let isLastItem = index == items.count - 1
            let connector = isLastItem ? "└── " : "├── "
            let icon: String
            let content = source.substring(with: item.contentRange)

            switch item.type {
            case .project:
                icon = "📁"
            case .task:
                icon = "☐"
            case .note:
                icon = "📝"
            }

            output += "\(prefix)\(connector)\(icon) \(content)"

            if !item.tags.isEmpty {
                let tags = item.tags.sorted(by: { $0.name < $1.name }).map { tag in
                    if let value = tag.value {
                        return "@\(tag.name)(\(value))"
                    } else {
                        return "@\(tag.name)"
                    }
                }.joined(separator: " ")
                output += " [\(tags)]"
            }

            output += "\n"

            if !item.children.isEmpty {
                let newPrefix = prefix + (isLastItem ? "    " : "│   ")
                formatItems(item.children, source: source, prefix: newPrefix, isLast: isLastItem, output: &output)
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
