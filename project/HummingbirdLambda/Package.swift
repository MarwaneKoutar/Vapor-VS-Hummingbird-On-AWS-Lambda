// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "HummingbirdLambda",
    platforms: [
        .macOS(.v14),
    ],
    dependencies: [
        .package(url: "https://github.com/hummingbird-project/hummingbird.git", from: "2.0.0-beta.4"),
        .package(url: "https://github.com/hummingbird-project/hummingbird-lambda.git", from: "2.0.0-beta.2"),
        .package(url: "https://github.com/soto-project/soto.git", from: "7.0.0-alpha.1"),
    ],
    targets: [
        .executableTarget(name: "HummingbirdApp", dependencies: [
            .product(name: "Hummingbird", package: "hummingbird"),
            .product(name: "HummingbirdLambda", package: "hummingbird-lambda"),
            .product(name: "SotoDynamoDB", package: "soto"),
        ]),
    ]
)
