import SwiftUI

struct TreatmentPlanCellView<TreatmentPlanRepositoryType: TreatmentPlanManageable>: View {
    let treatmentPlanRepository: TreatmentPlanRepositoryType
    
    var body: some View {
        if let treatmentPlan = treatmentPlanRepository.latest {
            let treatmentPlanDescription = "\(treatmentPlan.dosage.formatted(.number.precision(.fractionLength(1)))) mg \(treatmentPlan.ester.shortName) every \(treatmentPlan.frequency) days"
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
            .accessibilityHint("selected treatment plan, double tap to configure")
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
