import SwiftUI

struct SearchInactiveView: View {
    @State var showingSection = true
    
    let navigationItems: [AppArea]
    let actionItems: [ShortcutFeature]
    let allItems: [any SearchableItem]
    
    var body: some View {
        Group {
            Section("Navigation") {
                ForEach(navigationItems, id: \.id) { item in
                    SearchSuggestionCellView(configuration: .init(label: item.label,
                                                                  image: item.image,
                                                                  color: item.accentColor))
                    .listRowInsets(.bottom, 0)
                }
                .listRowSeparator(.hidden)
            }
            
            Section("Actions") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(actionItems, id: \.id) { item in
                            SearchActionCellView(configuration: .init(label: item.label,
                                                                      image: item.image))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .scrollTargetLayout()
                .listRowSeparator(.hidden)
                .listRowInsets(.vertical, 0)
            }
            
            Section(isExpanded: $showingSection) {
                ForEach(allItems, id: \.id) { item in
                    NavigationLink(destination: {
                        Text("Search Result")
                    }, label: {
                        SearchResultCellView(label: item.label, image: item.image)
                    })
                }
            } header: {
                Button {
                    withAnimation { showingSection.toggle() }
                } label: {
                    HStack {
                        Text("All Features")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: showingSection ? "chevron.down" : "chevron.right")
                            .font(.caption.weight(.semibold))
                    }
                }
                .buttonStyle(.plain)
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
