import SwiftUI

struct SearchInactiveView: View {
    @State var showingSection = true
    
    let navigationItems: [AppArea]
    let actionItems: [ShortcutFeature]
    let allItems: [any SearchableItem]
    
    var body: some View {
        Group {
            Section() {
                ForEach(navigationItems, id: \.id) { item in
                    SearchSuggestionCellView(configuration: .init(label: item.label,
                                                                  image: item.image,
                                                                  color: item.accentColor))
                    .listRowInsets(.bottom, .zero)
                }
                .listRowSeparator(.hidden)
            }
            
            Section("Actions") {
                ScrollView {
                    HStack {
                        ForEach(actionItems, id: \.id) { item in
                            SearchActionCellView(configuration: .init(label: item.label,
                                                                      image: item.image))
                        }
                    }
                }
                .listRowSeparator(.hidden)
            }
            
            Section("All Features", isExpanded: $showingSection) {
                ForEach(allItems, id: \.id) { item in
                    SearchResultCellView(label: item.label, image: item.image)
                }
            }
        }
    }
}

@MainActor
private extension LocalizedStringKey {
    static let discoverTitle: Self = "Discover"
    static let topPicksTitle: Self = "Top Picks"
    static let browseTitle: Self = "Browse All"
}
