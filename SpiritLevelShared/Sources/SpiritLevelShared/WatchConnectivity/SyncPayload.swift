import Foundation

public struct SyncPayload: Codable {
    public let injections: [InjectionTransfer]
    public let labResults: [LabResultTransfer]
    public let treatmentPlans: [TreatmentPlanTransfer]

    public init(
        injections: [InjectionTransfer],
        labResults: [LabResultTransfer],
        treatmentPlans: [TreatmentPlanTransfer]
    ) {
        self.injections = injections
        self.labResults = labResults
        self.treatmentPlans = treatmentPlans
    }
}

public struct InjectionTransfer: Codable {
    public let id: UUID
    public let dosage: Double
    public let date: Date
    public let ester: Ester
}

public struct LabResultTransfer: Codable {
    public let id: UUID
    public let concentration: Double
    public let date: Date
}

public struct TreatmentPlanTransfer: Codable {
    public let id: UUID
    public let name: String
    public let ester: Ester
    public let frequency: Int
    public let dosage: Double
    public let firstInjectionDate: Date
}

extension Injection {
    public var transferRepresentation: InjectionTransfer {
        InjectionTransfer(id: id, dosage: dosage, date: date, ester: ester)
    }
}

extension LabResult {
    public var transferRepresentation: LabResultTransfer {
        LabResultTransfer(id: id, concentration: concentration, date: date)
    }
}

extension TreatmentPlan {
    public var transferRepresentation: TreatmentPlanTransfer {
        TreatmentPlanTransfer(
            id: id,
            name: name,
            ester: ester,
            frequency: frequency,
            dosage: dosage,
            firstInjectionDate: firstInjectionDate
        )
    }
}
