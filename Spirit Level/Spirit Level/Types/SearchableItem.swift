import SwiftUI

// Matching systemImageName to achievement types is AI generated
// manual fine tuning by me was needed in around 1 in 3 times

protocol SearchableItem: Identifiable, Hashable, RawRepresentable where RawValue == String {
    var itemType: ItemType { get }
    var label: String { get }
    var systemImageName: String { get }
    var image: Image { get }
}

extension SearchableItem {
    var id: String { rawValue }
    var image: Image { Image(systemName: systemImageName) }
}
