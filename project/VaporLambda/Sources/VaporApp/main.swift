import Vapor
import VaporAWSLambdaRuntime
import SotoDynamoDB
import AWSLambdaEvents
import AWSLambdaRuntime

let app = Application()

let awsClient = AWSClient(credentialProvider: .default)

let dynamoDB = DynamoDB(client: awsClient, region: .euwest3)

try app.register(collection: GarageController(dynamoDB: dynamoDB, tableName: Environment.get("GARAGE_TABLE_NAME") ?? "Garage"))

app.servers.use(.lambda)
try app.run()
