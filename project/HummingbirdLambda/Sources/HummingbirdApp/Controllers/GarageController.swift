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
import Foundation
import Hummingbird
import HummingbirdLambda
import NIO
import SotoDynamoDB

struct GarageController {
    typealias Context = BasicLambdaRequestContext<APIGatewayRequest>

    let dynamoDB: DynamoDB
    let tableName: String

    func addRoutes(to group: RouterGroup<Context>) {
        group
            .get(use: self.list)
    }

    @Sendable func list(_ request: Request, context: Context) async throws -> [Car] {
        let input = DynamoDB.ScanInput(tableName: self.tableName)
        let response = try await self.dynamoDB.scan(input, type: Car.self, logger: context.logger)
        return response.items ?? []
    }
}
