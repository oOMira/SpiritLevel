import Foundation
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

    static var tone: AppDependenciesMock {
        .init(
            appStateManager: .init(),
            appStartRepository: .existing,
            injectionRepository: .tone,
            labResultsRepository: .tone,
            treatmentPlanRepository: .tone,
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
    var treatmentPlanRepository: TreatmentPlanMock
    var hormoneLevelManager: HormoneLevelManager

    init(
        appStateManager: AppStateMock,
        appStartRepository: AppStartRepositoryMock,
        injectionRepository: InjectionRepositoryMock,
        labResultsRepository: LabResultsMock,
        treatmentPlanRepository: TreatmentPlanMock,
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
