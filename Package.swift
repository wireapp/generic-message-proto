// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "GenericMessageProtocol",
    products: [
        .library(name: "GenericMessageProtocol", targets: ["GenericMessageProtocol"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.30.0"),
    ],
    targets: [
        .target(
            name: "GenericMessageProtocol",
            dependencies: [
                .product(name: "SwiftProtobuf", package: "swift-protobuf")
            ],
            path: "ios",
            exclude: [
                "README.md",
                "Tests",
                "messages.proto",
                "mls.proto",
                "otr.proto",
                "protoc.sh",
                // don't exclude for automatic code generation using the SwiftProtobufPlugin
                "swift-protobuf-config.json"
            ],
            // uncomment for automatic code generation (delete *.pb.swift files, create empty .swift file)
            // resources: [
            //     .process("swift-protobuf-config.json")
            // ]
            // plugins: [
            //     .plugin(name: "SwiftProtobufPlugin", package: "swift-protobuf")
            // ]
        ),
        .testTarget(
            name: "GenericMessageProtocolTests",
            dependencies: ["GenericMessageProtocol"],
            path: "ios/Tests"
        )
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("ExistentialAny")
    ]
}
