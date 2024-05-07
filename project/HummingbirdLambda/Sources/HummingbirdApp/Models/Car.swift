//===----------------------------------------------------------------------===//
//
// This source file is part of the Hummingbird server framework project
//
// Copyright (c) 2021-2024 the Hummingbird authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See hummingbird/CONTRIBUTORS.txt for the list of Hummingbird authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Foundation
import Hummingbird

struct Car: ResponseCodable {
    var carID: UUID
    var color: String
    var weight: Double
    var engineDisplacement: Double
    var horsepower: Double
    var torque: Double

    init(carID: UUID, color: String, weight: Double, engineDisplacement: Double, horsepower: Double, torque: Double) {
        self.carID = carID
        self.color = color
        self.weight = weight
        self.engineDisplacement = engineDisplacement
        self.horsepower = horsepower
        self.torque = torque
    }

    mutating func update(from car: Car) {
        self.color = car.color
        self.weight = car.weight
        self.engineDisplacement = car.engineDisplacement
        self.horsepower = car.horsepower
        self.torque = car.torque
    }
}
