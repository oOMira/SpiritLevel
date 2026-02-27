import SwiftUI

@MainActor
protocol AchievementsManageable: AnyObject, Observable {
    func isAchievementDone(_ achievement: Achievement, date: Date) -> Bool
}

@Observable
class AchievementsManager<InjectionRepositoryType: InjectionManageable,
                          TreatmentPlanRepositoryType: TreatmentPlanManageable,
                          LabResultsRepositoryType: LabResultsManageable,
                          AppStartRepositoryType: AppStartManageable>: AchievementsManageable {
    let injectionRepository: InjectionRepositoryType
    let treatmentPlanRepository: TreatmentPlanRepositoryType
    let labResultsRepository: LabResultsRepositoryType
    let appStartRepository: AppStartRepositoryType
    
    init(injectionRepository: InjectionRepositoryType,
         treatmentPlanRepository: TreatmentPlanRepositoryType,
         labResultsRepository: LabResultsRepositoryType,
         appStartRepository: AppStartRepositoryType) {
        self.injectionRepository = injectionRepository
        self.treatmentPlanRepository = treatmentPlanRepository
        self.labResultsRepository = labResultsRepository
        self.appStartRepository = appStartRepository
    }
    
    func isAchievementDone(_ achievement: Achievement, date: Date) -> Bool {
        let injections = injectionRepository.allItems
        let numberOfInjections = injections.count
        let numberOfLabResults = labResultsRepository.allItems.count
        let firstAppStart = appStartRepository.firstAppStart?.start ?? .distantFuture
        let plannedInjectionDateList = treatmentPlanRepository.allItems.getPlannedInjectionsList(till: date).map(\.date)
        let onTimeInjections = injections.filter { plannedInjectionDateList.contains($0.date.start) }.count
        switch achievement {
        case .sStreak: return onTimeInjections >= 5
        case .mStreak: return onTimeInjections >= 10
        case .lStreak: return  onTimeInjections >= 25
        case .sTime: return firstAppStart <= .now
        case .mTime: return Calendar.current.date(byAdding: .month, value: 6, to: firstAppStart) ?? .distantFuture  <= .now
        case .lTime: return Calendar.current.date(byAdding: .year, value: 1, to: firstAppStart) ?? .distantFuture  <= .now
        case .xlTime: return Calendar.current.date(byAdding: .year, value: 2, to: firstAppStart) ?? .distantFuture  <= .now
        case .firstInjection: return numberOfInjections >= 1
        case .sInjection: return numberOfInjections >= 10
        case .mInjection: return numberOfInjections >= 25
        case .lInjection: return numberOfInjections >= 50
        case .firstLab: return numberOfLabResults >= 1
        case .sLab: return numberOfLabResults >= 5
        case .mLab: return numberOfLabResults >= 10
        case .lLab: return numberOfLabResults >= 15
        }
    }
}
