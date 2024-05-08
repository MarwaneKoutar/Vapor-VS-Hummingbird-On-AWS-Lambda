import Vapor
import SotoDynamoDB

struct GarageController {
    let dynamoDB: DynamoDB
    let tableName: String
    
    init(dynamoDB: DynamoDB, tableName: String) {
        self.dynamoDB = dynamoDB
        self.tableName = tableName
    }

    func create(req: Request) async throws -> Response {
        var car = try req.content.decode(Car.self)

        car.carID = UUID()

        let input = DynamoDB.PutItemCodableInput(item: car, tableName: self.tableName)
        _ = try await self.dynamoDB.putItem(input)
        return try await car.encodeResponse(status: .created, for: req)
    }
    
    func list(req: Request) async throws -> [Car] {
        let input = DynamoDB.ScanInput(tableName: self.tableName)
        let scanResponse = try await self.dynamoDB.scan(input, type: Car.self)
        return scanResponse.items ?? []
    }

    func getAdvancedCalculations(req: Request) async throws -> Response {
        let cars = try await self.list(req: req)
        
        let totalPerformanceScore = cars.reduce(0.0) { $0 + $1.calculatePerformanceScore() }
        let averagePerformanceScore = totalPerformanceScore / Double(cars.count)
        
        let totalEcoRating = cars.reduce(0.0) { $0 + $1.calculateEcoRating() }
        let averageEcoRating = totalEcoRating / Double(cars.count)
        
        let responseBody: [String: Double] = [
            "averagePerformanceScore": averagePerformanceScore,
            "averageEcoRating": averageEcoRating
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: responseBody)
        var buffer = ByteBufferAllocator().buffer(capacity: jsonData.count)
        buffer.writeBytes(jsonData)
        return Response(
            status: .ok,
            body: Response.Body(buffer: buffer)
        )
    }

    func startFiscalInspection(req: Request) async throws -> Response {
        let cars = try await self.list(req: req)
        
        guard let carWithHighestPerformanceScore = cars.max(by: { $0.calculatePerformanceScore() < $1.calculatePerformanceScore() }) else {
            throw Abort(.notFound, reason: "No cars found")
        }
        
        let deleteRequest = DynamoDB.DeleteItemInput(
            key: ["carID": .s(carWithHighestPerformanceScore.carID!.uuidString)], tableName: tableName
        )
        _ = try await dynamoDB.deleteItem(deleteRequest)
        
        return Response(status: .ok)
    }

    func startSaboteur(req: Request) async throws -> Response {
        let cars = try await self.list(req: req)
        
        var updatedCars: [Car] = []
        for var car in cars {
            car.color = "Pink"
            updatedCars.append(car)
        }
        
        try await updateCars(updatedCars, req: req)
        
        return Response(status: .ok)
    }

    func updateCars(_ cars: [Car], req: Request) async throws {
        for car in cars {
            let input = DynamoDB.PutItemCodableInput(item: car, tableName: self.tableName)
            _ = try await self.dynamoDB.putItem(input)
        }
    }
}
