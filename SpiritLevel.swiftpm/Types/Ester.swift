import Foundation

enum Ester: String, CaseIterable, Identifiable, Codable, Hashable {
    case enanthate
    case valerate
    
    var id: String { rawValue }
    
    var configuration: Configuration {
        switch self {
        case .enanthate:
                .init(name: "Enanthate", cMax: 155, tMax: 8, tHalf: 15)
        case .valerate:
                .init(name: "Valerate", cMax: 410, tMax: 2, tHalf: 3)
        }
    }
        
    var name: String {
        configuration.name
    }
    
    var shortName: String {
        switch self {
        case .enanthate: "EE"
        case .valerate:  "EV"
        }
    }
}

extension Ester {
    struct Configuration: Identifiable {
        var id: String { name }
        let name: String
        let cMax: Double
        let tMax: Double
        let tHalf: Double
    }
}



extension Ester {
    var defaultDose: Double {
        switch self {
        case .enanthate: 5
        case .valerate: 5
        }
    }
    
    var defaultRhythm: Int {
        switch self {
        case .enanthate: 10
        case .valerate: 7
        }
    }
}
