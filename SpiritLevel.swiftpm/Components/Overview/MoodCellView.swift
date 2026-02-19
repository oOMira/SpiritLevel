import SwiftUI
import UIKit

struct MoodCellView: View {
    var body: some View {
        VStack {
            Image("smileCat")
                .resizable()
                .scaledToFit()
                .padding(35)
                .shadow(color: Color.primary.opacity(0.25), radius: 10, x: 0, y: 6)
                .frame(maxWidth: .infinity)
        }
        .background(Color.clear)
    }
}

#Preview {
    MoodCellView()
}
