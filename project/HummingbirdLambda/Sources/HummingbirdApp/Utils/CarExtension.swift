extension Car {
    func calculatePerformanceScore() -> Double {
        guard weight != 0 else { return 0 }
        return (horsepower * torque) / weight
    }
}
