import SwiftUI

struct AchievementsCellView<AchievementsManagerType: AchievementsManageable>: View {
    @ScaledMetric(relativeTo: .body) private var frameWidth: CGFloat = .baseFrameWidth
    @EnvironmentObject var appData: AppData
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    let achievementManager: AchievementsManagerType
    
    var body: some View {
        let frameDiff = .baseFrameWidth + .baseContentMargin - frameWidth
        let contentMargin = frameDiff < 0 ? 0 : frameDiff
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .contentSpacing) {
                let roundedRectangle = RoundedRectangle(cornerRadius: .cornerRadius,
                                                        style: .continuous)
                ForEach(Achievement.allCases) { achievement in
                    let isDone = achievementManager.isAchievementDone(achievement, date: appData.appStartDate)
                    achievement.image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: frameWidth)
                        .clipShape(roundedRectangle)
                        .shadow(color: .shadowColor,
                                radius: .shadowRadius,
                                x: .xShadowOffset,
                                y: .yShadowOffset)
                        .containerRelativeFrame(.horizontal,
                                                count: 1,
                                                spacing: .contentSpacing)
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
                                GeometryReader { proxy in
                                    Image(systemName: isDone
                                          ? "checkmark.circle"
                                          : "x.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: proxy.size.width / 4.0,
                                           height: proxy.size.height / 4.0)
                                    .padding(8)
                                    // important for readability
                                    .shadow(color: Color(uiColor: .systemBackground),
                                            radius: 5, x: 0, y: 0)
                                    .frame(maxWidth: .infinity,
                                           maxHeight: .infinity,
                                           alignment: .bottomTrailing)
                                    .accessibilityHidden(true)
                                }
                            }
                        }
                        .scrollTransition(.interactive,
                                          axis: .horizontal) { effect, phase in
                            let scale = 1.0 - min(0.15, abs(phase.value))
                            return effect.scaleEffect(CGFloat(scale))
                        }
                        .grayscale(isDone ? 0.0 : 1.0)
                        .contentShape(.accessibility, roundedRectangle)
                        .accessibilityValue(isDone ? "Completed" : "Not completed")
                }
            }
            .scrollTargetLayout()
        }
        .padding(.vertical)
        .scrollClipDisabled(true)
        .scrollTargetBehavior(.viewAligned)
        .contentMargins(.horizontal, contentMargin, for: .scrollContent)
    }
}

private extension CGFloat {
    static let contentSpacing: Self = 4.0
    static let cornerRadius: Self = 20.0
    static let shadowRadius: Self = 6.0
    static let xShadowOffset: Self  = 0.0
    static let yShadowOffset: Self  = 3.0
    static let baseFrameWidth: Self = 240.0
    static let baseContentMargin: Self = 50.0
}

private extension Color {
    static let shadowColor: Self = .black.opacity(0.2)
}
