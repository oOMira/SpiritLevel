import SwiftUI

struct MoodCellView<InjectionRepositoryType: InjectionManageable,
                    HormoneManagerType: HormoneLevelManageable>: View {
    
    let injectionRepository: InjectionRepositoryType
    let hormoneManager: HormoneManagerType
    let date: Date = .now

    var body: some View {
        let currentMood = self.mood
        return VStack(alignment: .center) {
            MoodView(mood: currentMood)
                .frame(width: .moodViewSize, height: .moodViewSize)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isImage)
        .accessibilityLabel("Emoji style image of a cat in a \(currentMood.rawValue) mood")
    }
    
    var mood: Mood {
        let isFalling = hormoneManager.isLevelFalling(injections: injectionRepository.allItems, date: .now) ?? false
        if injectionRepository.allItems.isEmpty {
            return .unclear
        } else {
            return  isFalling ? .sad : .happy
        }
    }
}

// MARK: - Constants

private extension CGFloat {
    static let moodViewSize: Self = 200
}
