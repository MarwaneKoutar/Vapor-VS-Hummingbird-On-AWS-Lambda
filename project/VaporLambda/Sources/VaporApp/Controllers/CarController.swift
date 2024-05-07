import Vapor
import SotoDynamoDB

struct CarController {
    let dynamoDB: DynamoDB
    
    init(dynamoDB: DynamoDB) {
        self.dynamoDB = dynamoDB
    }
    
    func getAll(req: Request) async throws -> [Car] {
        let input = DynamoDB.ScanInput(tableName: "Garage")
        let scanResponse = try await self.dynamoDB.scan(input, type: Car.self)
        return scanResponse.items ?? []
    }
}
