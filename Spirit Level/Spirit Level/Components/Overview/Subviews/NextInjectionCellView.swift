import SwiftUI

// MARK: - ViewModel

typealias NextInjectionCellDependencies = HasInjectionRepository & HasTreatmentPlanRepository

@Observable
final class NextInjectionCellViewModel<Dependencies: NextInjectionCellDependencies>: PlannedInjectionsManagable {
    var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func getNextInjectionDate(till date: Date) -> Date? {
        let startDate = date.start
        
        let latestPlan = dependencies.treatmentPlanRepository.allItems
            .sorted { $0.firstInjectionDate.start > $1.firstInjectionDate.start }
            .first
        
        guard let latestPlan else { return nil }

        guard latestPlan.firstInjectionDate.start <= startDate else { return latestPlan.firstInjectionDate.start }
        
        let lastPlannedDateTillNow = getPlannedInjectionsList(till: date)
            .sorted { $0.date.start > $1.date.start }
            .first
        
        let lastInjection = dependencies.injectionRepository.allItems
            .sorted { $0.date.start > $1.date.start }
            .first
                    
        guard let lastPlannedDateTillNow else { return startDate }
        guard let lastInjectionDate = lastInjection?.date.start else { return latestPlan.firstInjectionDate.start }
        guard let nextInjectionDate = Calendar.current.date(byAdding: .day,
                                                            value: latestPlan.frequency,
                                                            to: lastPlannedDateTillNow.date.start) else { return startDate }
        
        let loggedLastInjection = lastPlannedDateTillNow.date.start <= lastInjectionDate
        return loggedLastInjection ? nextInjectionDate : lastPlannedDateTillNow.date
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
        if let injectionDate = viewModel.getNextInjectionDate(till: appData.appStartDate) {
            HStack(spacing: 16) {
                Image(systemName: "calendar")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxHeight: imageWidth)
                VStack(alignment: .leading) {
                    Text(injectionDate, format: .dateTime.month(.wide).day().year())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.headline)
                    Text("Description")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .accessibilityElement(children: .combine)
            .padding(.leading, 4)
        } else {
            VStack(alignment: .center) {
                Text(.noTreatmentPlanTitle)
                    .font(.headline)
                Text(.noTreatmentPlanMessage)
                    .multilineTextAlignment(.center)
            }
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
