// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CAS iOS Functions Library",
    platforms: [
        .macOS(.v12),
        .iOS(.v26)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CAS iOS Functions Library",
            targets: ["CAS iOS Functions Library"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/techprimate/TPPDF", from: "2.6.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CAS iOS Functions Library",
            dependencies: [
                .product(name: "TPPDF", package: "TPPDF")
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
