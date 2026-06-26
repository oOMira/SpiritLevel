import Foundation
import OSLog
import SpiritLevelShared
import SwiftData

public protocol TreatmentPlanConfigurationManageable: Repository where ItemType == TreatmentPlanConfiguration { }

public protocol HasTreatmentPlanConfigurationRepository: AnyObject, Observable {
    associatedtype TreatmentPlanConfigurationRepo: TreatmentPlanConfigurationManageable
    var treatmentPlanConfigurationRepository: TreatmentPlanConfigurationRepo { get set }
}

@Observable
public final class TreatmentPlanConfigurationRepository: @MainActor TreatmentPlanConfigurationManageable, SwiftDataManageable {
    public var observationTask: Task<Void, Never>?
    public var modelContext: ModelContext
    public var allItems: [TreatmentPlanConfiguration] = []

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        refresh()
        // duplicates are in theory possible if the user has
        // multiple devices and they sync via iCloud.
        // This is a safeguard this get's resolved on restart.
        removeDuplicates()
        seedPredefinedIfNeeded()
        // Start observation last so save() calls during seeding don't trigger a redundant refresh.
        observeModelContext()
    }

    @MainActor deinit { observationTask?.cancel() }

    @discardableResult
    public func refresh() -> [TreatmentPlanConfiguration] {
        do {
            allItems = try fetchAll()
            return allItems
        } catch {
            Logger.data.error("Failed to refresh treatment plan configurations: \(error)")
            return []
        }
    }

    private func removeDuplicates() {
        Dictionary(grouping: allItems, by: \.id)
            .filter { $0.value.count > 1 }
            .flatMap { Array($0.value.dropFirst()) }
            .forEach {
                Logger.data.info("Removing duplicate treatment plan configuration: id=\($0.id) name=\($0.name)")
                do {
                    try delete(item: $0)
                } catch {
                    Logger.data.error("Failed to delete duplicate treatment plan configuration: \(error)")
                }
            }
    }

    private func seedPredefinedIfNeeded() {
        let existingIDs = Set(allItems.map(\.id))
        Ester.allCases
            .filter { !existingIDs.contains($0.predefinedPlanID) }
            .forEach {
                do {
                    try add(item: $0.predefinedPlan())
                } catch {
                    Logger.data.error("Failed to seed predefined treatment plan for \($0.rawValue): \(error)")
                }
            }
    }
}
