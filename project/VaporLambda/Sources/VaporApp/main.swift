import Vapor
import VaporAWSLambdaRuntime
import SotoDynamoDB
import AWSLambdaEvents
import AWSLambdaRuntime


let app = Application()

let awsClient = AWSClient(credentialProvider: .environment)

let dynamoDB = DynamoDB(client: awsClient, region: .euwest1)

registerRoutes(app, dynamoDB: dynamoDB)

app.servers.use(.lambda)
try app.run()
