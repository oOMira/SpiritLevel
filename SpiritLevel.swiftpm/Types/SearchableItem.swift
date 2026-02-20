import SwiftUI

protocol SearchableItem: CaseIterable, Identifiable, RawRepresentable where RawValue == String {
    var label: String { get }
    var systemImageName: String { get }
    var image: Image { get }
    var view: any View { get }
}

extension SearchableItem {
    var id: String { rawValue }
    var image: Image { Image(systemName: systemImageName) }
}
