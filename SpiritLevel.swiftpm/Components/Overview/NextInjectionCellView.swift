import SwiftUI

struct NextInjectionCellView: View {
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: Date())
    }

    var body: some View {
        Text(formattedDate)
    }
}
