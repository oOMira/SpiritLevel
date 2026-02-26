import SwiftUI

// MARK: - ViewModifier

struct SearchActiveViewModifier {
    
    // MARK: SearchItem
    
    struct SearchItemSelected: ViewModifier {
        func body(content: Content) -> some View {
            content
                .navigationDestination(for: SearchItem.self) { item in
                    item.configuration.getDestination()
                }
        }
    }
}

// MARK: - View+ViewModifier

extension View {
    func selectedSearchItemDestination() -> some View {
        modifier(SearchActiveViewModifier.SearchItemSelected())
    }
}
