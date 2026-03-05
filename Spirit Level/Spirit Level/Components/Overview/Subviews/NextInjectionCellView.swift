import SwiftUI

struct NextInjectionCellView<TreatmentPlanRepositoryType: TreatmentPlanManageable,
                             InjectionsReportRepositoryType: InjectionManageable>: View {

    @EnvironmentObject var appData: AppData

    let treatmentRepository: TreatmentPlanRepositoryType
    let injectionRepository: InjectionsReportRepositoryType
    
    var body: some View {
        if let injectionDate = getNextInjectionDate(till: appData.appStartDate.start) {
            Text(injectionDate, format: .dateTime.month(.wide).day().year())
                .accessibilityElement(children: .combine)
        } else {
            VStack(alignment: .leading) {
                Text(.noTreatmentPlanTitle)
                    .font(.headline)
                Text(.noTreatmentPlanMessage)
            }
            .accessibilityElement(children: .combine)
        }
    }
}

// MARK: - Helper

private extension NextInjectionCellView {
    // TODO: Untested and not readable
    func getNextInjectionDate(till date: Date) -> Date? {
        let sortedPlans = treatmentRepository.allItems.sorted { $0.firstInjectionDate.start > $1.firstInjectionDate.start }
        guard let latestPlan = sortedPlans.first else { return nil }
        guard latestPlan.firstInjectionDate.start < date.start else { return latestPlan.firstInjectionDate.start }
        let lastPlannedDateTillNow = sortedPlans.getPlannedInjectionsList(till: appData.appStartDate).sorted { $0.date.start > $1.date.start }.first?.date ?? date.start
        guard let latestInjectionDate = injectionRepository.allItems.sorted(by: { $0.date.start > $1.date.start }).first?.date else { return latestPlan.firstInjectionDate.start }
        return (latestInjectionDate < lastPlannedDateTillNow) ? lastPlannedDateTillNow : Calendar.current.date(byAdding: .day, value: latestPlan.frequency, to: lastPlannedDateTillNow.start) ?? date.start
    }
}

// MARK: - Constants

extension LocalizedStringResource {
        static let noTreatmentPlanTitle: Self = "No Treatment Plan"
        static let noTreatmentPlanMessage: Self = "Please set up your plan to see your next injection date"
}
