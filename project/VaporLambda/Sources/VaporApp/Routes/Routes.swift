import Vapor
import SotoDynamoDB

func registerRoutes(_ app: Application, dynamoDB: DynamoDB) {
    let carController = CarController(dynamoDB: dynamoDB)
    let cars = app.grouped("vaporapp", "cars")
    
    cars.get { req async throws -> [Car] in
        return try await carController.getAll(req: req)
    }
}
