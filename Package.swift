// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-inspect",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Inspect",
            targets: ["ArchiveHelper", "CodableExt", "Inspect"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ArchiveHelper",
            dependencies: []),
        .target(
            name: "CodableExt",
            dependencies: []),
        .testTarget(
            name: "CodableExtTests",
            dependencies: ["CodableExt"]),
        .target(
            name: "Inspect",
            dependencies: [
                .byName(name: "ArchiveHelper"),
                .byName(name: "CodableExt"),
            ]),
    ]
)
