import SwiftUI

struct AchievementsView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    let isDone: Bool
    
    var body: some View {
        List {
            ForEach(Achievement.allCases) { achivement in
                HStack {
                    achivement.image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: .cornerRadius,
                                                    style: .continuous))
                        .frame(width: .frameWidth)
                        .grayscale(isDone ? 0.0 : 1.0)
                        .opacity(accessibilityDifferentiateWithoutColor ? 0.5 : 1.0)
                        .accessibilityIgnoresInvertColors()
                        .overlay {
                            if accessibilityDifferentiateWithoutColor {
                                Image(systemName: isDone
                                      ? "checkmark.circle"
                                      : "x.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .frame(maxHeight: .infinity, alignment: .center)
                                .padding(4)
                                .accessibilityHidden(true)
                            }
                        }
                    VStack {
                        Text(achivement.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(achivement.description)
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityValue(isDone ? "done" : "")
            }
        }
        .listStyle(.plain)
        .navigationTitle(.navigationTitle)
    }
}

// MARK: - Constants

private extension CGFloat {
    static let frameWidth: CGFloat = 50
    static let cornerRadius: CGFloat = 8
}
private extension LocalizedStringKey {
    static let navigationTitle: Self = "Achievements"
}

// MARK: - Preview

#Preview("Light Mode") {
    NavigationStack {
        AchievementsView(isDone: false)
    }
    .preferredColorScheme(.light)
}

#Preview("Light Mode - Done") {
    NavigationStack {
        AchievementsView(isDone: true)
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationStack {
        AchievementsView(isDone: false)
    }
    .preferredColorScheme(.dark)
}

#Preview("Dark Mode - Done") {
    NavigationStack {
        AchievementsView(isDone: true)
    }
    .preferredColorScheme(.dark)
}

