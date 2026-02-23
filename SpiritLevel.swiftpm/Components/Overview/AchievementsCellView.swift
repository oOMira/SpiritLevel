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
                        .clipShape(RoundedRectangle(cornerRadius: .cornerRadius,
                                                    style: .continuous))
                        .shadow(color: .shadowColor,
                                radius: .shadowRadius,
                                x: .xShadwoOffset,
                                y: .yShadwoOffset)
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
        .contentMargins(.horizontal, .contentMargins, for: .scrollContent)
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
    static let contentMargins: Self  = 50.0
    static let contentSpacing: Self = 4.0
    static let cornerRadius: Self = 20.0
    static let shadowRadius: Self = 6.0
    static let xShadwoOffset: Self  = 0.0
    static let yShadwoOffset: Self  = 3.0
}

private extension Color {
    static let shadowColor: Self = .black.opacity(0.2)
}
