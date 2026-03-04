@testable import Spirit_Level

@MainActor
protocol Mockable {
    static var one: Self { get }
    static var tone: Self { get }
    static var none: Self { get }
}

protocol MockableRepository: SwiftDataManageable, Mockable { }
