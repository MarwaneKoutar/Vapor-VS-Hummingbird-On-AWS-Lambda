//===----------------------------------------------------------------------===//
//
// This source file is part of the Hummingbird server framework project
//
// Copyright (c) 2021-2024 the Hummingbird authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See hummingbird/CONTRIBUTORS.txt for the list of Hummingbird authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import AWSLambdaEvents
import AWSLambdaRuntime
import HummingbirdLambda
import Logging
import SotoDynamoDB

@main
struct MyHandler: APIGatewayV2LambdaFunction {
    let awsClient: AWSClient
    let logger: Logger

    init(context: LambdaInitializationContext) {
        self.awsClient = AWSClient(credentialProvider: .default)
        self.logger = context.logger
    }

    func buildResponder() -> some HTTPResponder<Context> {
        let tableName = Environment.shared.get("GARAGE_TABLE_NAME") ?? "Garage"
        self.logger.info("Using table \(tableName)")
        let dynamoDB = DynamoDB(client: awsClient, region: .euwest3)

        let router = Router(context: Context.self)
        
        GarageController(dynamoDB: dynamoDB, tableName: tableName).addRoutes(to: router.group("hummingbirdapp/cars"))
        
        return router.buildResponder()
    }

    func shutdown() async throws {
        try await self.awsClient.shutdown()
    }
}
