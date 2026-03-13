import SwiftUI
import Lottie

struct MoodCellView<InjectionRepositoryType: InjectionManageable,
                    HormoneManagerType: HormoneLevelManageable>: View {
    
    @ScaledMetric(relativeTo: .body) private var moodSize: CGFloat = 200
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var playing: Bool = false
    
    let injectionRepository: InjectionRepositoryType
    let hormoneManager: HormoneManagerType
    let date: Date = .now

    var body: some View {
        let currentMood = self.mood
        return VStack(alignment: .center) {
            LottieView(animation: .named(currentMood.resourceName))
                .playbackMode(
                    reduceMotion
                        ? (!playing ? .paused(at: .progress(0)) : .playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce)))
                        : .playing(.fromProgress(0, toProgress: 1, loopMode: .loop))
                )
                .animationDidFinish { _ in
                    guard reduceMotion else { return }
                    playing = false
                }
                .reloadAnimationTrigger(playing, showPlaceholder: false)
                .grayscale(currentMood == .unclear ? 1 : 0)
                .onTapGesture {
                    guard reduceMotion else { return }
                    playing = true
                }
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: moodSize, maxHeight: moodSize)
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

// MARK: - Helper

private extension Mood {
    var resourceName: String {
        switch self {
        case .happy: "smilecat"
        case .sad: "cryingcat"
        case .unclear: "smileycat"
        }
    }
}
