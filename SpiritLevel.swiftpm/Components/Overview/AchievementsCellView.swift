import SwiftUI

struct AchievementsCellView: View {
    @ObservedObject private var appState = AppStateManager.shared
    @State private var scrolledID: Achievement.ID?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .contentSpacing) {
                ForEach(Achievement.allCases) { achievement in
                    achievement.image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20,
                                                    style: .continuous))
                        .shadow(color: .black.opacity(0.2),
                                radius: 6,
                                x: 0,
                                y: 3)
                        .containerRelativeFrame(.horizontal,
                                                count: 1,
                                                spacing: .contentSpacing)
                        .scrollTransition(.interactive,
                                          axis: .horizontal) { effect, phase in
                            let scale = 1.0 - min(0.15, abs(phase.value))
                            return effect.scaleEffect(CGFloat(scale))
                        }
                        .grayscale(1.0)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $scrolledID)
        .scrollClipDisabled(true)
        .scrollTargetBehavior(.viewAligned)
        .contentMargins(.horizontal, 50, for: .scrollContent)
        .onAppear {
            scrolledID = appState.selectedAchievement.isEmpty ? Achievement.allCases.first?.id : appState.selectedAchievement
        }
        .onChange(of: scrolledID) { _, newID in
            guard let newID else { return }
            appState.selectedAchievement = newID
        }
    }
}

private extension CGFloat {
    static let contentSpacing: Self = 4.0
}
