import SwiftUI
import HealthDataLogging

// MARK: - ViewModel

typealias NextInjectionCellDependencies = HasInjectionRepository & HasTreatmentPlanRepository

@Observable
final class NextInjectionCellViewModel<Dependencies: NextInjectionCellDependencies>: InjectionDateManageable {
    var dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - View

struct NextInjectionCellView<Dependencies: NextInjectionCellDependencies>: View {

    @Environment(AppData.self) var appData: AppData
    @ScaledMetric(relativeTo: .body) private var imageWidth: CGFloat = 30

    private var viewModel: NextInjectionCellViewModel<Dependencies>

    init(viewModel: NextInjectionCellViewModel<Dependencies>) {
        self.viewModel = viewModel
    }

    var body: some View {
        if let injectionDate = viewModel.getNextInjectionDate(until: appData.appStartDate) {
            HStack(spacing: 16) {
                Image(systemName: "calendar")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxHeight: imageWidth)
                VStack(alignment: .leading, spacing: 4) {
                    Text(injectionDate, format: .dateTime.month(.wide).day().year())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.headline)
                    Text("Your next injection date")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .listRowInsets(.vertical, 6)
            .accessibilityElement(children: .combine)
            .padding(.leading, 4)
        } else {
            VStack(alignment: .center) {
                Text(.noTreatmentPlanTitle)
                    .font(.headline)
                Text(.noTreatmentPlanMessage)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .accessibilityElement(children: .combine)
            .padding()
        }
    }
}

// MARK: - Constants

extension LocalizedStringResource {
    static let noTreatmentPlanTitle: Self = "No Treatment Plan"
    static let noTreatmentPlanMessage: Self = "Please set up your plan to see your next injection date"
}
