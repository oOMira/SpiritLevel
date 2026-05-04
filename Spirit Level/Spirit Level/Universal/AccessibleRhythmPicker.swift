import SwiftUI

/// A stepper that lets the user choose an injection rhythm between 1 and 31 days.
///
/// Displays "Repeat every N days" and provides combined VoiceOver accessibility.
struct AccessibleRhythmPicker: View {
    /// The injection frequency in days.
    @Binding private var rhythm: Int

    /// Creates a rhythm picker bound to the given frequency value.
    /// - Parameter rhythm: A binding to the injection frequency in days.
    init(rhythm: Binding<Int>) {
        self._rhythm = rhythm
    }

    var body: some View {
        Stepper("Repeat every \(rhythm) days", value: $rhythm, in: .rhythmRange)
            .accessibilityElement(children: .combine)
    }
}

private extension ClosedRange where Bound == Int {
    static let rhythmRange: Self = 1...31
}
