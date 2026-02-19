import SwiftUI
import UIKit

struct MoodCellView: View {
    var body: some View {
        VStack(alignment: .center) {
            MoodView(mood: .happy)
                .frame(width: 200, height: 200)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MoodCellView()
}
