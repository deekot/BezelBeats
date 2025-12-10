// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BezelBeats",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "BezelBeats", targets: ["BezelBeats"])
    ],
    targets: [
        .executableTarget(
            name: "BezelBeats",
            path: "Sources",
            resources: [.process("FluidShader.metal")]
        )
    ]
)
