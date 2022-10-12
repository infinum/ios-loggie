// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Loggie",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "Loggie",
            targets: ["Loggie"]),
    ],
    dependencies: [
        .package(
		url: "https://github.com/Alamofire/Alamofire.git", 
		.exact("5.2")
	)
    ],
    targets: [
        .target(
            name: "Loggie",
            dependencies: ["Alamofire"],
            path: "Loggie/Classes"
        ),
    ]
)
