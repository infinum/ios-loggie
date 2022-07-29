// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Loggie",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "Loggie",
            targets: ["Loggie"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Loggie",
            dependencies: [],
            path: "Loggie/Classes"
        ),
    ]
)
