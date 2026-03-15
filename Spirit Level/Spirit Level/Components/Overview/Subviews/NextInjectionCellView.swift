import SwiftUI

struct NextInjectionCellView<TreatmentPlanRepositoryType: TreatmentPlanManageable,
                             InjectionsReportRepositoryType: InjectionManageable>: View {
    
    @Environment(AppData.self) var appData: AppData
    @ScaledMetric(relativeTo: .body) private var imageWidth: CGFloat = 30
    
    let treatmentRepository: TreatmentPlanRepositoryType
    let injectionRepository: InjectionsReportRepositoryType
    
    var body: some View {
        let injectionDate = getNextInjectionDate(till: appData.appStartDate)
        if let injectionDate = injectionDate {
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
