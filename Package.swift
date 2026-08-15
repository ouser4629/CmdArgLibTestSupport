// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CmdArgLibTestSupport",
    platforms: [.macOS(.v12)],
    products: [
        .library( name: "CmdArgLibTestSupport", targets: ["CmdArgLibTestSupport"] ),
        .executable( name: "print-m", targets: ["PrintM"] ),
    ],
    dependencies: [
        .package(url: "https://github.com/ouser4629/CmdArgLibCore.git", branch: "main"),
        .package(url: "https://github.com/ouser4629/CmdArgLibMacros.git", branch: "main"),
        .package(url: "https://github.com/ouser4629/CmdArgLibHelpScreen.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "CmdArgLibTestSupport",
            dependencies: [ "CmdArgLibCore" ],
        ),
        .executableTarget(
            name: "PrintM",
            dependencies: ["PrintMSource"]
        ),
        .target(
            name:"PrintMSource",
            dependencies: [
                "CmdArgLibCore", "CmdArgLibMacros", "CmdArgLibHelpScreen",
            ]
        ),
        .testTarget(
            name:"PrintMTests",
            dependencies: [
               "PrintM", "CmdArgLibCore", "CmdArgLibTestSupport"
            ]
        ),
    ]
)
