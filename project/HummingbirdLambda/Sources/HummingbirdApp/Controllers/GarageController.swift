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
    typealias Context = BasicLambdaRequestContext<APIGatewayV2Request>

    let dynamoDB: DynamoDB
    let tableName: String

    func addRoutes(to group: RouterGroup<Context>) {
        group
            .post(use: self.create)
            .get(use: self.list)
            .get("advanced-calculations", use: self.getAdvancedCalculations)
            .delete("fiscal-inspection", use: self.startFiscalInspection)
            .put("saboteur", use: self.startSaboteur)
    }

    @Sendable func create(_ request: Request, context: Context) async throws -> EditedResponse<Car> {
        let car = try await request.decode(as: Car.self, context: context)
        let input = DynamoDB.PutItemCodableInput(item: car, tableName: self.tableName)
        _ = try await self.dynamoDB.putItem(input, logger: context.logger)
        return EditedResponse(status: .created, response: car)
    }

    @Sendable func list(_ request: Request, context: Context) async throws -> [Car] {
        let input = DynamoDB.ScanInput(tableName: self.tableName)
        let response = try await self.dynamoDB.scan(input, type: Car.self, logger: context.logger)
        return response.items ?? []
    }

    @Sendable func getAdvancedCalculations(_ request: Request, context: Context) async throws -> Response {
        let cars = try await self.list(request, context: context)

        let totalPerformanceScore = cars.reduce(0.0) { $0 + $1.calculatePerformanceScore() }
        let averagePerformanceScore = totalPerformanceScore / Double(cars.count)

        let totalEcoRating = cars.reduce(0.0) { $0 + $1.calculateEcoRating() }
        let averageEcoRating = totalEcoRating / Double(cars.count)

        let responseBody: [String: Double] = [
            "averagePerformanceScore": averagePerformanceScore,
            "averageEcoRating": averageEcoRating
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: responseBody)
        var buffer = context.allocator.buffer(capacity: jsonData.count)
            buffer.writeBytes(jsonData)
        return Response(
            status: .ok,
            body: ResponseBody(byteBuffer: buffer)
        )
    }

    @Sendable func startFiscalInspection(_ request: Request, context: Context) async throws -> Response {
        let cars = try await self.list(request, context: context)

        guard let carWithHighestPerformanceScore = cars.max(by: { $0.calculatePerformanceScore() < $1.calculatePerformanceScore() }) else {
            throw HTTPError(.notFound, message: "No cars found")
        }

        let deleteRequest = DynamoDB.DeleteItemInput(
            key: ["carID": .s(carWithHighestPerformanceScore.carID.uuidString)], tableName: tableName
        )
        _ = try await dynamoDB.deleteItem(deleteRequest, logger: context.logger)

        return Response(status: .ok)
    }

    @Sendable func startSaboteur(_ request: Request, context: Context) async throws -> Response {
        let cars = try await self.list(request, context: context)
        
        var updatedCars: [Car] = []
        for var car in cars {
            car.color = "Pink"
            updatedCars.append(car)
        }

        try await updateCars(updatedCars, context: context)

        return Response(status: .ok)
    }

    @Sendable func updateCars(_ cars: [Car], context: Context) async throws {
        for car in cars {
            let input = DynamoDB.PutItemCodableInput(item: car, tableName: self.tableName)
            _ = try await self.dynamoDB.putItem(input, logger: context.logger)
        }
    }
}
