import SwiftUI

struct AchievementsView: View {
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
                        .padding(.trailing)
                    VStack {
                        Text(achivement.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(achivement.description)
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
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
        AchievementsView()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationStack {
        AchievementsView()
    }
    .preferredColorScheme(.dark)
}

