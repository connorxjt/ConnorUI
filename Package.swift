// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ConnorUI",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "ConnorUI",
            targets: ["ConnorUI"]
        )
    ],
    targets: [
        .target(
            name: "ConnorUI"
        )
    ]
)
