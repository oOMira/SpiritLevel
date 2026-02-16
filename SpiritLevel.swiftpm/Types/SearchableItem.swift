import SwiftUI

protocol SearchableItem: CaseIterable, Identifiable, RawRepresentable where RawValue == String {
    var label: String { get }
    var systemImageName: String { get }
    var image: Image { get }
    var deepLink: URL { get }
}

extension SearchableItem {
    var id: String { rawValue }
    
    var image: Image { Image(systemName: systemImageName) }
    
    var deepLink: URL {
        URL(string: "spiritlevel://\(rawValue)")!
    }
}
