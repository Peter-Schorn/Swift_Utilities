// swift-tools-version:5.2
// The swift-tools-version declares the minimum
// version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Utilities",
    platforms: [
        .iOS(.v9), .macOS(.v10_10), .watchOS(.v2), .tvOS(.v9)
    ],
    products: [
        // Products define the executables and libraries produced
        // by a package, and make them visible to other packages.
        .library(
            name: "Utilities",
            targets: ["Utilities"]
        ),
        .library(
            name: "XCTestCaseExtensions",
            targets: ["XCTestCaseExtensions"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(
            name: "RegularExpressions",
            url: "https://github.com/Peter-Schorn/RegularExpressions",
            "2.0.0"..<"3.0.0"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package.
        // A target can define a module or a test suite.
        // Targets can depend on other targets in this package,
        // and on products in packages which this package depends on.
        .target(
            name: "Utilities",
            dependencies: ["RegularExpressions"]
        ),
        .target(
            name: "XCTestCaseExtensions",
            dependencies: ["Utilities"]
        ),
        .testTarget(
            name: "UtilitiesTests",
            dependencies: [
                "Utilities",
                "RegularExpressions",
                "XCTestCaseExtensions"
            ]
        )
    ]
)
