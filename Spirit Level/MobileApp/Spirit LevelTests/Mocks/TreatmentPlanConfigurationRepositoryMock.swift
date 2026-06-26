import Foundation
import HealthDataLogging

class TreatmentPlanConfigurationRepositoryMock: TreatmentPlanConfigurationManageable {
    func refresh() -> [HealthDataLogging.TreatmentPlanConfiguration] { allItems }

    init(allItems: [TreatmentPlanConfiguration] = []) {
        self.allItems = allItems
    }

    var allItems: [TreatmentPlanConfiguration]

    func add(item: TreatmentPlanConfiguration) throws {
        allItems.append(item)
    }

    func delete(item: TreatmentPlanConfiguration) throws {
        allItems.removeAll { $0 == item }
    }

    func deleteAll() throws {
        allItems = []
    }
}

extension TreatmentPlanConfigurationRepositoryMock {
    static var one: TreatmentPlanConfigurationRepositoryMock {
        let item = TreatmentPlanConfiguration(name: "Default",
                                              ester: .enanthate,
                                              frequency: 7,
                                              dosage: 1.0,
                                              visible: true,
                                              editable: false)
        return .init(allItems: [item])
    }

    static var many: TreatmentPlanConfigurationRepositoryMock {
        let predefined = Ester.allCases.map { $0.predefinedPlan() }
        let custom = TreatmentPlanConfiguration(name: "Custom",
                                                ester: .enanthate,
                                                frequency: 5,
                                                dosage: 2.0,
                                                visible: true,
                                                editable: true)
        return .init(allItems: predefined + [custom])
    }

    static var none: TreatmentPlanConfigurationRepositoryMock { .init() }
}
