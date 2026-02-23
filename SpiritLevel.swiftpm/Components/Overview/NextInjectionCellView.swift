import SwiftUI

struct NextInjectionCellView: View {
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = .dateFormat
        return formatter.string(from: Date())
    }

    var body: some View {
        Text(formattedDate)
    }
}

// MARK: - Constants

private extension String {
    static let dateFormat = "dd.MM.yyyy"
}

// MARK: - Preview

#Preview("Light Mode") {
    List {
        Section("Next Injection") {
            NextInjectionCellView()
        }
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    List {
        Section("Next Injection") {
            NextInjectionCellView()
        }
    }
    .preferredColorScheme(.dark)
}
