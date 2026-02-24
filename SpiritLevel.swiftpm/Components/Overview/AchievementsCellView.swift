import SwiftUI

struct AchievementsCellView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .contentSpacing) {
                ForEach(Achievement.allCases) { achievement in
                    achievement.image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300.0)
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
        .padding(.vertical)
        .scrollClipDisabled(true)
        .scrollTargetBehavior(.viewAligned)
        .contentMargins(.horizontal, .contentMargins, for: .scrollContent)
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
