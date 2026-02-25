import SwiftUI

struct MoodCellView: View {
    var body: some View {
        VStack(alignment: .center) {
            MoodView(mood: .happy)
                .frame(width: .moodViewSize, height: .moodViewSize)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Constants

private extension CGFloat {
    static let moodViewSize: Self = 200
}
