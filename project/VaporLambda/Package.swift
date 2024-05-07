// swift-tools-version: 5.9.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VaporLambda",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "VaporApp", targets: ["VaporApp"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/vapor-community/vapor-aws-lambda-runtime", .upToNextMajor(from: "0.6.2")),
        .package(url: "https://github.com/soto-project/soto.git", from: "7.0.0-alpha.1")
    ],
    targets: [
        .executableTarget(
            name: "VaporApp",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "VaporAWSLambdaRuntime", package: "vapor-aws-lambda-runtime"),
                .product(name: "SotoDynamoDB", package: "soto")
            ]
        )
    ]
)
