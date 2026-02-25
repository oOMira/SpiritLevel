import SwiftUI

extension SettingsView {
    struct TreatmentPlanCellView: View {
        var body: some View {
            HStack {
                Image(systemName: .planIcon)
                    .font(.title2)
                    .padding(.horizontal, .iconHorizontalPadding)
                VStack {
                    Text(.treatmentPlanTitle)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(.planDetails)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.footnote)
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(.treatmentPlanTitle)
            .accessibilityValue(.planDetails)
            .accessibilityHint("selected treatment plan, double tap to configure")
        }
    }
}

// MARK: - Constants

private extension String {
    static let planIcon = "list.bullet.rectangle.portrait"
}

private extension LocalizedStringKey {
    static let treatmentPlanTitle: Self = "Treatment Plan"
    static let planDetails: Self = "5mg every 10 days"
}

private extension CGFloat {
    static let iconHorizontalPadding: Self = 4
}

// MARK: - Preview

#Preview("Light Mode") {
    List {
        SettingsView.TreatmentPlanCellView()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    List {
        SettingsView.TreatmentPlanCellView()
    }
    .preferredColorScheme(.dark)
}
