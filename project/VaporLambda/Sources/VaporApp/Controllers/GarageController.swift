import Vapor
import SotoDynamoDB

struct PerformanceResponse: Content {
    let averagePerformanceScore: Double
    let cars: [Car]
}

struct GarageController: RouteCollection {
    let dynamoDB: DynamoDB
    let tableName: String

    func boot(routes: RoutesBuilder) throws {
        let cars = routes.grouped("vaporapp", "cars")
        
        cars.get(use: list)
        cars.post(use: create)
        cars.get("simulated-performance", use: simulatedPerformance)
        cars.delete("fiscal-inspection", use: startFiscalInspection)
        cars.put("saboteur", use: startSaboteur)
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

    func simulatedPerformance(req: Request) async throws -> PerformanceResponse {
        let randomCars = generateRandomCars(10)
        let performanceScores = randomCars.map { $0.calculatePerformanceScore() }
        let averagePerformanceScore = performanceScores.reduce(0.0, +) / Double(performanceScores.count)
        
        let response = PerformanceResponse(
            averagePerformanceScore: averagePerformanceScore,
            cars: randomCars
        )
        
        return response
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
