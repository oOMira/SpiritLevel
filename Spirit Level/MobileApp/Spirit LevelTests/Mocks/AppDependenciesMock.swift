import Foundation
import HealthDataLogging
@testable import Spirit_Level

extension AppDependenciesMock {
    static var one: AppDependenciesMock {
        .init(
            appStateManager: .init(),
            appStartRepository: .existing,
            injectionRepository: .one,
            labResultsRepository: .one,
            treatmentPlanRepository: .one,
            hormoneLevelManager: HormoneLevelManager()
        )
    }

    static var many: AppDependenciesMock {
        .init(
            appStateManager: .init(),
            appStartRepository: .existing,
            injectionRepository: .many,
            labResultsRepository: .many,
            treatmentPlanRepository: .many,
            hormoneLevelManager: HormoneLevelManager()
        )
    }

    static var none: AppDependenciesMock {
        .init(
            appStateManager: .init(),
            appStartRepository: .new,
            injectionRepository: .none,
            labResultsRepository: .none,
            treatmentPlanRepository: .none,
            hormoneLevelManager: HormoneLevelManager()
        )
    }
}

@Observable
@MainActor
class AppDependenciesMock: AppDependenciesProtocol {
    var appStateManager: AppStateMock
    var appStartRepository: AppStartRepositoryMock
    var injectionRepository: InjectionRepositoryMock
    var labResultsRepository: LabResultsMock
    var treatmentPlanRepository: TreatmentPlanManagerMock
    var hormoneLevelManager: HormoneLevelManager

    init(
        appStateManager: AppStateMock,
        appStartRepository: AppStartRepositoryMock,
        injectionRepository: InjectionRepositoryMock,
        labResultsRepository: LabResultsMock,
        treatmentPlanRepository: TreatmentPlanManagerMock,
        hormoneLevelManager: HormoneLevelManager
    ) {
        self.appStateManager = appStateManager
        self.appStartRepository = appStartRepository
        self.injectionRepository = injectionRepository
        self.labResultsRepository = labResultsRepository
        self.treatmentPlanRepository = treatmentPlanRepository
        self.hormoneLevelManager = hormoneLevelManager
    }
}
