import SwiftUI
import Lottie

struct MoodCellView: View {
    var body: some View {
        LottieView(animation: .named("lottie"))
            .frame(width: 200, height: 200)
    }
}

#Preview {
    MoodCellView()
}
