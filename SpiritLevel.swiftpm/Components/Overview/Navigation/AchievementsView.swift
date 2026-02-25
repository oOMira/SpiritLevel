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
                .accessibilityValue(isDone ? "Completed" : "Not completed")
            }
        }
        .listStyle(.plain)
        .navigationTitle(.navigationTitle)
        .accessibilityRotor("Completed Achievements") {
            ForEach(Achievement.allCases) { achievement in
                if isDone {
                    AccessibilityRotorEntry(achievement.name, id: achievement.id)
                }
            }
        }
        .accessibilityRotor("Incomplete Achievements") {
            ForEach(Achievement.allCases) { achievement in
                if !isDone {
                    AccessibilityRotorEntry(achievement.name, id: achievement.id)
                }
            }
        }
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

