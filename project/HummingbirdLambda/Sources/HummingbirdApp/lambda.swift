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
struct AppLambda: APIGatewayLambdaFunction {
    let awsClient: AWSClient
    let logger: Logger

    init(context: LambdaInitializationContext) {
        self.awsClient = AWSClient(credentialProvider: .default)
        self.logger = context.logger
    }

    func buildResponder() -> some HTTPResponder<Context> {
        // let tableName = Environment.shared.get("GARAGE_TABLE_NAME") ?? "Garage"
        // self.logger.info("Using table \(tableName)")
        // let dynamoDB = DynamoDB(client: awsClient, region: .euwest3)

        let router = Router(context: Context.self)
        // middleware
        // router.middlewares.add(ErrorMiddleware())
        // router.middlewares.add(LogRequestsMiddleware(.debug))
        // router.middlewares.add(CORSMiddleware(
        //     allowOrigin: .originBased,
        //     allowHeaders: [.contentType],
        //     allowMethods: [.get, .options, .post, .delete, .patch]
        // ))
        //GarageController(dynamoDB: dynamoDB, tableName: tableName).addRoutes(to: router.group("hummingbirdapp/cars"))

        router.get("hummingbirdapp") { request, _ -> String in
            return "Hello"
        }

        return router.buildResponder()
    }

    func shutdown() async throws {
        try await self.awsClient.shutdown()
    }
}

struct ErrorMiddleware<Context: BaseRequestContext>: RouterMiddleware {
    func handle(
        _ input: Request,
        context: Context,
        next: (Request, Context) async throws -> Response
    ) async throws -> Response {
        do {
            return try await next(input, context)
        } catch let error as HTTPError {
            throw error
        } catch {
            throw HTTPError(.internalServerError, message: "Error: \(error)")
        }
    }
}
