// swift-tools-version:6.1

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
            plugins: [
                .plugin(name: "SwiftProtobufPlugin", package: "swift-protobuf")
            ]
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
