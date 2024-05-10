import Foundation
import Hummingbird

struct Car: ResponseCodable {
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

    mutating func update(from car: EditCar) {
        if let color = car.color {
            self.color = color
        }
        if let weight = car.weight {
            self.weight = weight
        }
        if let engineDisplacement = car.engineDisplacement {
            self.engineDisplacement = engineDisplacement
        }
        if let horsepower = car.horsepower {
            self.horsepower = horsepower
        }
        if let torque = car.torque {
            self.torque = torque
        }
    }

    mutating func update(from car: Car) {
        self.color = car.color
        self.weight = car.weight
        self.engineDisplacement = car.engineDisplacement
        self.horsepower = car.horsepower
        self.torque = car.torque
    }
}

struct EditCar: ResponseCodable {
    var carID: UUID?
    var color: String?
    var weight: Double?
    var engineDisplacement: Double?
    var horsepower: Double?
    var torque: Double?
}