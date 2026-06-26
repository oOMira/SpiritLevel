import Foundation
import HealthDataLogging
import SpiritLevelShared

class InjectionRepositoryMock: InjectionManageable {
    func refresh() -> [HealthDataLogging.Injection] { allItems }
    
    init(allItems: [Injection] = []) {
        self.allItems = allItems
    }

    var allItems: [Injection]

    func add(item: Injection) throws {
        allItems.append(item)
    }

    func delete(item: Injection) throws {
        allItems.removeAll { $0 == item }
    }

    func deleteAll() throws {
        allItems = []
    }

    func refresh() { }
}

extension InjectionRepositoryMock {
    static var one: InjectionRepositoryMock {
        let item = Injection(ester: .enanthate, dosage: 1.0, date: .distantPast)
        return .init( allItems: [item])
    }

    static var many: InjectionRepositoryMock {
        let date = Date()
        let items = (0...100).map {
            Injection(ester: .valerate, dosage: Double($0), date: date)
        }
        return .init(allItems: items)
    }

    static var none: InjectionRepositoryMock { .init() }
}
