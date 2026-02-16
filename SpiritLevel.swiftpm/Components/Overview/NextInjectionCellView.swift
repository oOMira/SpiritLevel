import SwiftUI

struct NextInjectionCellView: View {
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: Date())
    }

    var body: some View {
        Text(formattedDate)
    }
}
