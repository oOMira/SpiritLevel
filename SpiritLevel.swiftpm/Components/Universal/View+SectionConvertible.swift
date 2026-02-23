import SwiftUI

extension View {
    func asSectionWithTitle(_ title: LocalizedStringKey) -> any View {
        Section(title, content: { self })
    }
}
