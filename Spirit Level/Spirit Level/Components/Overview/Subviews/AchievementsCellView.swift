import SwiftUI

struct AchievementsCellView<AchievementsManagerType: AchievementsManageable>: View {
    @State var size: CGSize = .zero
    @ScaledMetric(relativeTo: .body) private var frameWidth: CGFloat = .baseFrameWidth
    @EnvironmentObject var appData: AppData
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    let achievementManager: AchievementsManagerType
    
    private let roundedRectangle = RoundedRectangle(cornerRadius: .cornerRadius,
                                            style: .continuous)
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .contentSpacing) {
                ForEach(Achievement.allCases) { achievement in
                    achievementCell(achievement)
                }
            }
            .scrollTargetLayout()
        }
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newSize in
            size = newSize
        }
        .contentMargins(.horizontal,
                        contentMargin(for: size.width),
                        for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
        .padding(.vertical)
        .scrollClipDisabled(true)
    }
    
    @ViewBuilder
    private func achievementCell(_ achievement: Achievement) -> some View {
        let isDone = achievementManager.isAchievementDone(achievement, date: appData.appStartDate)
        
        achievement.image
            .resizable()
            .scaledToFit()
            .containerRelativeFrame(.horizontal) { size, _ in
                frameWidth > size ? size : frameWidth
            }
            .clipShape(roundedRectangle)
            .shadow(color: .shadowColor,
                    radius: .shadowRadius,
                    x: .xShadowOffset,
                    y: .yShadowOffset)
            .accessibilityIgnoresInvertColors()
            .accessibilityRemoveTraits([.isImage, .isButton])
            .accessibilityLabel(achievement.name)
            .accessibilityValue(isDone ? "Completed" : "Not completed")
            .accessibilityAction(named: "Describe Image") {
                let imageDescription = isDone
                    ? achievement.imageDescription
                    : "\(achievement.imageDescription) - grayedOut"
                UIAccessibility.post(
                    notification: .announcement,
                    argument: imageDescription
                )
            }
            .overlay(alignment: .bottomTrailing) {
                if accessibilityDifferentiateWithoutColor {
                    accessibilityOverlay(isDone: isDone)
                }
            }
            .scrollTransition(.interactive,
                              axis: .horizontal) { effect, phase in
                let scale = 1.0 - (abs(phase.value) * 0.15)
                return effect.scaleEffect(CGFloat(max(0.85, scale)))
            }
            .grayscale(isDone ? 0.0 : 1.0)
            .contentShape(.accessibility, roundedRectangle)
    }
    
    private func accessibilityOverlay(isDone: Bool) -> some View {
        GeometryReader { proxy in
            Image(systemName: isDone ? "checkmark.circle" : "x.circle")
                .resizable()
                .scaledToFit()
                .frame(width: proxy.size.width / 4.0,
                       height: proxy.size.height / 4.0)
                .padding(8)
                .shadow(color: Color(uiColor: .systemBackground),
                        radius: 5, x: 0, y: 0)
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .bottomTrailing)
                .accessibilityHidden(true)
        }
    }
    
    private func contentMargin(for scrollViewWidth: CGFloat) -> CGFloat {
        let diff = scrollViewWidth - frameWidth
        return diff > frameWidth ? 0 : max(0, diff / 2)
    }
}

private extension CGFloat {
    static let contentSpacing: Self = 16.0
    static let cornerRadius: Self = 20.0
    static let shadowRadius: Self = 6.0
    static let xShadowOffset: Self  = 0.0
    static let yShadowOffset: Self  = 3.0
    static let baseFrameWidth: Self = 200.0
}

private extension Color {
    static let shadowColor: Self = .black.opacity(0.2)
}
