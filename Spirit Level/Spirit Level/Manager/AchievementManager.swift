import SwiftUI

typealias AchievementsManagerDependencies = HasInjectionRepository & HasTreatmentPlanRepository & HasLabResultsRepository & HasAppStartRepository

@MainActor
protocol AchievementsManageable: AnyObject, Observable, PlannedInjectionsManagable where Dependencies: AchievementsManagerDependencies {
    var dependencies: Dependencies { get }
    func isAchievementDone(_ achievement: Achievement, date: Date) -> Bool
}

extension AchievementsManageable {
    private var injections: [Injection] { dependencies.injectionRepository.allItems }
    private var numberOfInjections: Int { injections.count }
    private var numberOfLabResults: Int { dependencies.labResultsRepository.allItems.count }
    private var firstAppStart: Date { dependencies.appStartRepository.firstAppStart?.start ?? .distantFuture }
        
    
    func isAchievementDone(_ achievement: Achievement, date: Date) -> Bool {
        let plannedInjectionDateList = getPlannedInjectionsList(till: date).map(\.date)
        let numberOnTimeInjections = injections.filter { plannedInjectionDateList.contains($0.date.start) }.count

        switch achievement {
        case .sStreak: return numberOnTimeInjections >= 5
        case .mStreak: return numberOnTimeInjections >= 10
        case .lStreak: return  numberOnTimeInjections >= 25
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
