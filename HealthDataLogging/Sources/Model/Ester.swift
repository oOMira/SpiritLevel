import Foundation

public enum Ester: String, CaseIterable, Identifiable, Codable, Hashable, Sendable {
    case enanthate
    case valerate

    public var id: String { rawValue }

    public var configuration: Configuration {
        switch self {
        case .enanthate:
                .init(name: "Enanthate", cMax: 155, tMax: 8, tHalf: 15)
        case .valerate:
                .init(name: "Valerate", cMax: 410, tMax: 2, tHalf: 3)
        }
    }

    public var name: String {
        configuration.name
    }

    public var shortName: String {
        switch self {
        case .enanthate: "EE"
        case .valerate:  "EV"
        }
    }
}

extension Ester {
    public struct Configuration: Identifiable {
        public var id: String { name }
        public let dose: Double = 5.0
        public let name: String
        public let cMax: Double
        public let tMax: Double
        public let tHalf: Double
    }
}

extension Ester {
    public var defaultDose: Double {
        switch self {
        case .enanthate: 5
        case .valerate: 5
        }
    }

    public var defaultRhythm: Int {
        switch self {
        case .enanthate: 10
        case .valerate: 7
        }
    }
}
