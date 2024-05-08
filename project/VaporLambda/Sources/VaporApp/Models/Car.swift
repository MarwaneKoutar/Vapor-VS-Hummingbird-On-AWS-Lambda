import Vapor

struct Car: Content {
    var carID: UUID?
    var color: String
    var weight: Double
    var engineDisplacement: Double
    var horsepower: Double
    var torque: Double

    init(carID: UUID? = nil, color: String, weight: Double, engineDisplacement: Double, horsepower: Double, torque: Double) {
        self.carID = carID
        self.color = color
        self.weight = weight
        self.engineDisplacement = engineDisplacement
        self.horsepower = horsepower
        self.torque = torque
    }
}
