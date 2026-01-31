// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZenCalendar",
    platforms: [
        .macOS(.v13) // macOS Ventura or later for MenuBarExtra
    ],
    products: [
        .executable(name: "ZenCalendar", targets: ["ZenCalendar"])
    ],
    dependencies: [
        .package(url: "https://github.com/6tail/lunar-swift", branch: "master")
    ],
    targets: [
        .executableTarget(
            name: "ZenCalendar",
            dependencies: [
                .product(name: "LunarSwift", package: "lunar-swift")
            ],
            path: "Sources/ZenCalendar",
            resources: [
                .process("Assets")
            ]
        )
    ]
)
