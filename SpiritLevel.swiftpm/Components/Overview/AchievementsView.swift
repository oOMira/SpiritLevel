import SwiftUI

struct AchievementsView: View {
    var body: some View {
        List {
            ForEach(Achievement.allCases) { achivement in
                HStack {
                    achivement.image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 8,
                                                    style: .continuous))
                        .frame(width: 50)
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
        .navigationTitle("Achievements")
    }
}
