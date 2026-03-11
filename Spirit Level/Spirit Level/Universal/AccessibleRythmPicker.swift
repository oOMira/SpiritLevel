import SwiftUI

struct AccessibleRythmPicker: View {
    @Binding private var rhythm: Int
    
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
