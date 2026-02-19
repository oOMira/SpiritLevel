import SwiftUI

struct AchivementsCellView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .contentSpacing) {
                ForEach(Achievement.allCases) { achivement in
                    achivement.image
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
        .scrollClipDisabled(true)
        .scrollTargetBehavior(.viewAligned)
        .contentMargins(.horizontal, 55, for: .scrollContent)
    }
}

private extension CGFloat {
    static let contentSpacing: Self = 4.0
}
