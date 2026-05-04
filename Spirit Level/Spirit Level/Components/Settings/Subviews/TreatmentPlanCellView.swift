import SwiftUI

struct TreatmentPlanCellView<TreatmentPlanRepo: TreatmentPlanManageable>: View {
    let treatmentPlanRepository: TreatmentPlanRepo

    var body: some View {
        if let treatmentPlan = treatmentPlanRepository.getLatest() {
            let doseDescription = treatmentPlan.dosage.formatted(
                .number.precision(.fractionLength(1))
            )
            let treatmentPlanDescription =
                "\(doseDescription) mg \(treatmentPlan.ester.shortName) every \(treatmentPlan.frequency) days"
            HStack {
                Image(systemName: .planIcon)
                    .font(.title2)
                    .padding(.horizontal, .iconHorizontalPadding)
                VStack {
                    Text(.treatmentPlanTitle)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(treatmentPlanDescription)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.footnote)
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(.treatmentPlanTitle)
            .accessibilityValue(treatmentPlanDescription)
            .accessibilityHint("Selected treatment plan. Double-tap to configure.")
        } else {
            TreatmentPlanMissingView()
        }
    }

}

private extension TreatmentPlanCellView {
    struct TreatmentPlanMissingView: View {
        var body: some View {
            Text("Set up treatment plan")
        }
    }
}

// MARK: - Constants

private extension String {
    static let planIcon = "list.bullet.rectangle.portrait"
}

private extension LocalizedStringResource {
    static let treatmentPlanTitle: Self = "Treatment Plan"
}

private extension CGFloat {
    static let iconHorizontalPadding: Self = 4
}

// MARK: - Previews

#Preview("Light Mode") {
    List {
        TreatmentPlanCellView(treatmentPlanRepository: Mocks.treatmentPlanRepository)
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    List {
        TreatmentPlanCellView(treatmentPlanRepository: Mocks.treatmentPlanRepository)
    }
    .preferredColorScheme(.dark)
}
