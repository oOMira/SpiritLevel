import SwiftUI

struct Overview: View {
    @AppStorage("moodExpanded") private var isMoodExpanded: Bool = true

    var body: some  View {
        NavigationView {
            List {
                Section {
                    if isMoodExpanded {
                        MoodCellView()
                    }
                } header: {
                    Button(action: toggleMoodExpanded) {
                        HStack {
                            Text("Mood")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: isMoodExpanded ? "chevron.down" : "chevron.right")
                                .font(.caption.weight(.semibold))
                        }
                    }
                    .buttonStyle(.plain)
                }
                Section("Current Level") {
                    CurrentLevelCellView()
                }
                Section("Next Injection") {
                    NextInjectionCellView()
                }
                Section("Trend") {
                    TrendCellView(name: "Consistency", trend: .up)
                    TrendCellView(name: "HormoneLevel", trend: .down)
                }
                
                Section {
                    AchivementsCellView()
                        .listRowBackground(Color.clear)
                } header: {
                    NavigationLink(destination: {
                        AchievementsView()
                    }, label: {
                        HStack {
                            Text("Achivements")
                            Image(systemName: "chevron.forward")
                                .font(.caption.weight(.semibold))
                        }
                    })
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle(.navigationTitle)
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()
                    ActionPill(
                        onTap: onTap,
                        onLongPress: onLongPress
                    )
                    .padding(.trailing)
                    .padding(.bottom, 8)
                }
            }
        }
    }
}

// MARK: - Helper

extension Overview {
    private func toggleMoodExpanded() {
        withAnimation(.easeInOut) {
            isMoodExpanded.toggle()
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
