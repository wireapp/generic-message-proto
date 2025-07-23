# Swift Package for iOS

## Updating the generated code

```sh
cd ios
./protoc.sh --swift_opt=Visibility=Public --swift_opt=UseAccessLevelOnImports=true --swift_out=. *.proto
```

## Adding the library to a project

To use the generated code add "https://github.com/wireapp/generic-message-proto.git" with min version 1.53.0 to the project.

```Swift
dependencies: [
    .package(url: "https://github.com/wireapp/generic-message-proto.git", from: "1.53.0")
],
targets: [
    .target(
        name: "MyTarget",
        dependencies: [
            .product(name: "GenericMessageProtocol", package: "generic-message-proto")
        ]
    ),
]
```
