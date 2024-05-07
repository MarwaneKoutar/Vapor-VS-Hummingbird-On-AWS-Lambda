import Vapor

struct Car: Content {
    var carID: UUID
    var color: String
    var weight: Double
    var engineDisplacement: Double
    var horsepower: Double
    var torque: Double
}
