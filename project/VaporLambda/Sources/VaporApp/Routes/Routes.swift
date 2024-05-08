import Vapor
import SotoDynamoDB

func registerRoutes(_ app: Application, dynamoDB: DynamoDB) {
    let carController = CarController(dynamoDB: dynamoDB, tableName: Environment.get("GARAGE_TABLE_NAME") ?? "Garage")
    let cars = app.grouped("vaporapp", "cars")
    
    cars.get { req async throws -> [Car] in
        return try await carController.list(req: req)
    }

    cars.post { req async throws -> Response in
        return try await carController.create(req: req)
    }

    cars.get("advanced-calculations") { req async throws -> Response in
        return try await carController.getAdvancedCalculations(req: req)
    }

    cars.delete("fiscal-inspection") { req async throws -> Response in
        return try await carController.startFiscalInspection(req: req)
    }

    cars.put("saboteur") { req async throws -> Response in
        return try await carController.startSaboteur(req: req)
    }
}
