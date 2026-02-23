import SwiftUI
import UIKit

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

// MARK: - Preview

#Preview("Light Mode") {
    List {
        MoodCellView()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    List {
        MoodCellView()
    }
    .preferredColorScheme(.dark)
}
