import Foundation
import Hummingbird

struct Car: ResponseCodable {
    var carID: UUID?
    var color: String
    var weight: Double
    var horsepower: Double
    var torque: Double

    init(carID: UUID? = nil, color: String, weight: Double, horsepower: Double, torque: Double) {
        self.carID = carID
        self.color = color
        self.weight = weight
        self.horsepower = horsepower
        self.torque = torque
    }
}
