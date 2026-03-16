import SwiftUI
import Lottie

// MARK: - ViewModel

typealias MoodCellDependencies = HasInjectionRepository & HasHormoneLevelManager

@Observable
final class MoodCellViewModel<Dependencies: MoodCellDependencies> {
    var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - View

struct MoodCellView<Dependencies: MoodCellDependencies>: View {
    @ScaledMetric(relativeTo: .body) private var moodSize: CGFloat = 200
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var playing: Bool = false
    
    let viewModel: MoodCellViewModel<Dependencies>
    let date: Date = .now
    
    init(dependencies: Dependencies) {
        self.viewModel = .init(dependencies: dependencies)
    }

    var body: some View {
        let currentMood = self.mood
        return VStack(alignment: .center) {
            LottieView(animation: .named(currentMood.resourceName))
                .playbackMode(lottiePlaybackMode)
                .animationDidFinish { _ in
                    if reduceMotion { playing = false }
                }
                .reloadAnimationTrigger(playing, showPlaceholder: false)
                .grayscale(currentMood == .unclear ? 1 : 0)
                .shadow(radius: 2)
                .onTapGesture {
                    if reduceMotion { playing = true }
                }
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: moodSize, maxHeight: moodSize)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isImage)
        .accessibilityLabel("Emoji style image of a cat in a \(currentMood.rawValue) mood")
    }
    
    // MARK: - Helper
    
    var lottiePlaybackMode: Lottie.LottiePlaybackMode {
        if reduceMotion {
            if playing {
                .playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
            } else {
                .paused(at: .progress(0))
            }
        } else {
            .playing(.fromProgress(0, toProgress: 1, loopMode: .loop))
        }
    }
    
    var mood: Mood {
        .unclear
//        let isFalling = hormoneManager.isLevelFalling(injections: injectionRepository.allItems, date: .now) ?? false
//        if injectionRepository.allItems.isEmpty {
//            return .unclear
//        } else {
//            return  isFalling ? .sad : .happy
//        }
    }
}

// MARK: - Mood+Helper

private extension Mood {
    var resourceName: String {
        switch self {
        case .happy: "smilecat"
        case .sad: "cryingcat"
        case .unclear: "smileycat"
        }
    }
}
