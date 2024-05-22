import AWSLambdaEvents
import Foundation
import Hummingbird
import HummingbirdLambda
import NIO
import SotoDynamoDB

struct PerformanceResponse: Codable {
    let averagePerformanceScore: Double
    let cars: [Car]
}

struct GarageController {
    typealias Context = BasicLambdaRequestContext<APIGatewayV2Request>

    let dynamoDB: DynamoDB
    let tableName: String

    func addRoutes(to group: RouterGroup<Context>) {
        group
            .post(use: self.create)
            .get(use: self.list)
            .get("simulated-performance", use: self.simulatedPerformance)
            .delete("fiscal-inspection", use: self.startFiscalInspection)
            .put("saboteur", use: self.startSaboteur)
    }

    @Sendable func create(_ request: Request, context: Context) async throws -> EditedResponse<Car> {
        var car = try await request.decode(as: Car.self, context: context)

        car.carID = UUID()

        let input = DynamoDB.PutItemCodableInput(item: car, tableName: self.tableName)
        _ = try await self.dynamoDB.putItem(input, logger: context.logger)
        return EditedResponse(status: .created, response: car)
    }

    @Sendable func list(_ request: Request, context: Context) async throws -> [Car] {
        let input = DynamoDB.ScanInput(tableName: self.tableName)
        let response = try await self.dynamoDB.scan(input, type: Car.self, logger: context.logger)
        return response.items ?? []
    }

    @Sendable func simulatedPerformance(_ request: Request, context: Context) async throws -> Response {
        let randomCars = generateRandomCars(10)
        let performanceScores = randomCars.map { $0.calculatePerformanceScore() }
        let averagePerformanceScore = performanceScores.reduce(0.0, +) / Double(performanceScores.count)
        
        let response = PerformanceResponse(
            averagePerformanceScore: averagePerformanceScore,
            cars: randomCars
        )
        
        let jsonData = try JSONEncoder().encode(response)
        var buffer = context.allocator.buffer(capacity: jsonData.count)
        buffer.writeBytes(jsonData)
        
        return Response(
            status: .ok,
            body: .init(byteBuffer: buffer)
        )
    }

    func generateRandomCars(_ count: Int) -> [Car] {
        var cars: [Car] = []
        for _ in 0..<count {
            let car = Car(
                carID: UUID(),
                color: ["Red", "Blue", "Green", "Yellow", "Black", "White"].randomElement()!,
                weight: Double.random(in: 1000...3000),
                horsepower: Double.random(in: 100...400),
                torque: Double.random(in: 100...400)
            )
            cars.append(car)
        }
        return cars
    }

    @Sendable func startFiscalInspection(_ request: Request, context: Context) async throws -> Response {
        let cars = try await self.list(request, context: context)

        guard let carWithHighestPerformanceScore = cars.max(by: { $0.calculatePerformanceScore() < $1.calculatePerformanceScore() }) else {
            throw HTTPError(.notFound, message: "No cars found")
        }

        let deleteRequest = DynamoDB.DeleteItemInput(
            key: ["carID": .s(carWithHighestPerformanceScore.carID!.uuidString)], tableName: tableName
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
