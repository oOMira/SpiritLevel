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
                            let scale = 1.0 - min(0.1, abs(phase.value) * 0.1)
                            return effect.scaleEffect(CGFloat(scale))
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollClipDisabled(true)
        .scrollTargetBehavior(.viewAligned)
        .contentMargins(.horizontal, 40, for: .scrollContent)
    }
}

private extension CGFloat {
    static let contentSpacing: Self = 16.0
}
