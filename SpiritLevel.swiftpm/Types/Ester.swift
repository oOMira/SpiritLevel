import Foundation

enum Ester: String, CaseIterable, Identifiable {
    case enanthate
    case valerate
    
    var id: String { rawValue }
    
    var configuration: Configuration {
        switch self {
        case .enanthate:
                .init(name: "Enanthate", cMax: 160, tMax: 6.5, tHalf: 11.6, tNinetyPercent: 21.6)
        case .valerate:
                .init(name: "Valerate", cMax: 295, tMax: 2.1, tHalf: 5.1, tNinetyPercent: 12)
        }
    }
    
    var points: [Point] { [
        .init(0.0, 0.0),
        .init(configuration.tMax, configuration.cMax),
        .init(configuration.tHalf, configuration.cMax / 2),
        .init(configuration.tNinetyPercent, configuration.cMax / 10)
    ] }
    
    var name: String {
        configuration.name
    }
}

extension Ester {
    struct Configuration: Identifiable {
        var id: String { name }
        let name: String
        let cMax: Double
        let tMax: Double
        let tHalf: Double
        let tNinetyPercent: Double
    }
}



extension Ester {
    var defaultDose: Double {
        switch self {
        case .enanthate: 5
        case .valerate: 5
        }
    }
    
    var defaultRythm: Int {
        switch self {
        case .enanthate: 10
        case .valerate: 7
        }
    }
}
