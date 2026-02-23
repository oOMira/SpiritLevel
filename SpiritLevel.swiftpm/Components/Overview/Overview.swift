import SwiftUI

struct Overview: View {
    @State private var activeSheet: ShortcutFeature?
    @ObservedObject private var appState = AppStateManager.shared
    
    var body: some  View {
        ZStack(alignment: .bottomTrailing) {
            List {
                Section {
                    if appState.isMoodExpanded { MoodCellView() }
                } header: {
                    ExpandableSectionHeader(title: .moodTitle, expanded: $appState.isMoodExpanded)
                }
                
                Section("Current Level") {
                    CurrentHormoneLevelCellView()
                }

                Section("Next Injection") {
                    NextInjectionCellView()
                }

                Section("Trend") {
                    TrendCellView(name: "Consistency", trend: .up)
                    TrendCellView(name: "HormoneLevel", trend: .down)
                }
                
                Section {
                    AchievementsCellView()
                        .listRowBackground(Color.clear)
                } header: {
                    NavigationLink(destination: {
                        AchievementsView()
                    }, label: {
                        HStack {
                            Text("Achievements")
                            Image(systemName: "chevron.forward")
                                .font(.caption.weight(.semibold))
                        }
                    })
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle(.navigationTitle)
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .logInjection: LogInjectionView()
                    .presentationDetents([.medium, .large])
                case .logLab: LogLabView()
                    .presentationDetents([.medium, .large])
                }
            }

            let quickActions: [QuickActionsControl.ActionConfiguration] = ShortcutFeature.allCases.map { feature in
                .init(feature: feature, action: {
                    activeSheet = feature
                })
            }

            QuickActionsControl(actions: quickActions)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 16)
                .padding(.trailing, 16)
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

// MARK: - Helper

extension Overview {
    private func toggleMoodExpanded() {
        withAnimation(.easeInOut) {
            appState.isMoodExpanded.toggle()
        }
    }
    
    private func onTap() {
        print("Tapped")
    }
    
    private func onLongPress() {
        print("Long pressed")
    }
}

// MARK: - Constants

@MainActor
private extension LocalizedStringKey {
    static let navigationTitle: Self = "Overview"
    static let moodTitle: Self = "Mood"
}

// MARK: - Preview

#Preview {
    Overview()
}

