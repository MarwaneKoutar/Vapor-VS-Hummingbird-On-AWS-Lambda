import AWSLambdaEvents
import AWSLambdaRuntime
import HummingbirdLambda
import Logging
import SotoDynamoDB

@main
struct HummingbirdApp: APIGatewayV2LambdaFunction {
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
