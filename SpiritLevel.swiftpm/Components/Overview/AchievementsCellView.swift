import SwiftUI

struct AchievementsCellView: View {
    let isDone: Bool
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .contentSpacing) {
                let roundedRectangle = RoundedRectangle(cornerRadius: .cornerRadius,
                                                        style: .continuous)
                ForEach(Achievement.allCases) { achievement in
                    achievement.image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300.0)
                        .clipShape(roundedRectangle)
                        .shadow(color: .shadowColor,
                                radius: .shadowRadius,
                                x: .xShadwoOffset,
                                y: .yShadwoOffset)
                        .containerRelativeFrame(.horizontal,
                                                count: 1,
                                                spacing: .contentSpacing)
                        .accessibilityIgnoresInvertColors()
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
