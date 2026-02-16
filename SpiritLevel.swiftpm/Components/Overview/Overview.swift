import SwiftUI

struct Overview: View {
    var body: some  View {
        NavigationView {
            List {
                Section("Mood") {
                    MoodCellView()
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
                Section("Achivements") {
                    Text("Drei")
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
