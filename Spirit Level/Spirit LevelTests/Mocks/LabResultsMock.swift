import Foundation
@testable import Spirit_Level

class LabResultsMock: LabResultsManageable {
    init(allItems: [LabResult] = []) {
        self.allItems = allItems
    }

    var allItems: [LabResult]

    func add(item: LabResult) throws {
        allItems.append(item)
    }

    func delete(item: LabResult) throws {
        allItems.removeAll { $0 == item }
    }

    func deleteAll() throws {
        allItems = []
    }
}

extension LabResultsMock {
    static var one: LabResultsMock {
        let item = LabResult(concentration: 250.0, date: .distantPast)
        return .init(allItems: [item])
    }

    static var many: LabResultsMock {
        let date = Date()
        let items = (0...50).map {
            LabResult(concentration: CGFloat($0) * 10.0, date: date)
        }
        return .init(allItems: items)
    }

    static var none: LabResultsMock { .init() }
}
