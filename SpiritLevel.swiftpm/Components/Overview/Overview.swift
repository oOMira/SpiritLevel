import SwiftUI

struct Overview: View {
    @ObservedObject private var appState = AppStateManager.shared
    
    var body: some  View {
        ZStack(alignment: .bottomTrailing) {
            List {
                Section {
                    if appState.isMoodExpanded {
                        MoodCellView()
                    }
                } header: {
                    Button(action: toggleMoodExpanded) {
                        HStack {
                            Text("Mood")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "chevron.down")
                                .font(.caption.weight(.semibold))
                                .rotationEffect(.degrees(appState.isMoodExpanded ? 0 : -90))
                        }
                    }
                    .buttonStyle(.plain)
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
            
            QuickActionsControl(actions: [
                .init(feature: .logInjection, action: { print("log injeciton") }),
                .init(feature: .logLab, action: { print("log lab") }),
                
            ])
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
}

// MARK: - Preview

#Preview {
    Overview()
}
