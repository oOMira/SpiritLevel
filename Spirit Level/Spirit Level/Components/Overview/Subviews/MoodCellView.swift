import SwiftUI
import Lottie

// MARK: - ViewModel

typealias MoodCellDependencies = HasInjectionRepository & HasTreatmentPlanRepository & HasHormoneLevelManager

@Observable
final class MoodCellViewModel<Dependencies: MoodCellDependencies> {
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func getMood(at date: Date) -> Mood {
        let frequency = dependencies.treatmentPlanRepository.latest?.frequency
        guard let lastInjection = dependencies.injectionRepository.last,
              let nextInjection = Calendar.current.date(byAdding: .day,
                                                        value: frequency ?? lastInjection.ester.defaultRhythm,
                                                        to: lastInjection.date) else { return .unclear }

        let tMax = lastInjection.ester.configuration.tMax * 24 * 60 * 60
        
        let injectionDate = lastInjection.date
        let risingMid = injectionDate.addingTimeInterval(tMax / 2)
        let peak = injectionDate.addingTimeInterval(tMax)
        let fallingMid = peak.addingTimeInterval(nextInjection.timeIntervalSince(peak) / 2)
        
        let injections = dependencies.injectionRepository.allItems
        let isLevelFalling = dependencies.hormoneLevelManager.isLevelFallingForInjections(injections, at: date)

        return switch date {
        case injectionDate...risingMid:
            isLevelFalling ? .unsure : .happy 
        case risingMid...peak:
            isLevelFalling ? .unsure : .confident
        case peak...fallingMid:
            isLevelFalling ? .pouting : .unsure
        case fallingMid...nextInjection:
            isLevelFalling ? .sad : .unsure
        case nextInjection...Date.distantFuture:
            isLevelFalling ? .sad : .unsure
        default: .unclear
        }
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
        let currentMood = viewModel.getMood(at: date)
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
}

// MARK: - Mood+Helper

private extension Mood {
    var resourceName: String {
        switch self {
        case .happy: "smilecat"
        case .sad: "cryingcat"
        case .unclear: "smileycat"
        case .pouting: "poutingcat"
        case .confident: "heartcat"
        case .unsure: "smileycat"
        }
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    MoodCellView(dependencies: Mocks.appDependencies)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    MoodCellView(dependencies: Mocks.appDependencies)
        .preferredColorScheme(.dark)
}
