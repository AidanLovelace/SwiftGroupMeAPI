// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GroupMeAPI",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "GroupMeAPI",
            targets: ["GroupMeAPI"]),
    ],
    dependencies: [
        .package(name: "Promises", url: "https://github.com/google/promises.git", from: "1.2.8"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "GroupMeAPI",
            dependencies: [.product(name: "Promises", package: "Promises")]),
    ]
)
