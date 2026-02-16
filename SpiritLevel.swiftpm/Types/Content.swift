import SwiftUI

struct Content {
    static var allTypes: [any SearchableItem.Type] { [
        AppArea.self,
        OverviewFeature.self,
        SettingsFeature.self,
        StatisticsFeature.self
    ] }
    
    static var allItems: [any SearchableItem] {
        allTypes.flatMap { type in
            type.allCases.compactMap { $0 as? any SearchableItem }
        }
    }
    
    static func resolve(rawValue: String) -> (any SearchableItem)? {
        allTypes.lazy
            .compactMap { $0.init(rawValue: rawValue) }
            .first
    }
}
