import SwiftUI

protocol SearchableItem: Identifiable, Hashable, RawRepresentable where RawValue == String {
    var label: String { get }
    var systemImageName: String { get }
    var image: Image { get }
}

extension SearchableItem {
    var id: String { rawValue }
    var image: Image { Image(systemName: systemImageName) }
}
