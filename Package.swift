// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "taskpaper-lint",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "taskpaper-lint",
            targets: ["taskpaper-lint"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0"),
        .package(url: "https://github.com/deverman/TaskPaper.git", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "taskpaper-lint",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "TaskPaper", package: "TaskPaper")
            ],
            path: "Sources/taskpaper-lint"
        ),
        .testTarget(
            name: "taskpaper-lint-tests",
            dependencies: ["taskpaper-lint"],
            path: "Tests/taskpaper-lint-tests"
        )
    ]
)
