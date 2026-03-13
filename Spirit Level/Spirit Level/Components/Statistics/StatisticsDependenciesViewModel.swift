import SwiftUI

typealias StatisticsDependencies = HasInjectionRepository & HasLabResultsRepository & HasHormoneLevelManager

@Observable
final class StatisticsContentViewModel<Dependencies: StatisticsDependencies> {
    var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}
