// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Pomo",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(name: "Pomo"),
        .testTarget(name: "PomoTests", dependencies: ["Pomo"]),
    ]
)
