import Foundation

extension Ester {
    public func predefinedPlan() -> TreatmentPlanConfiguration {
        .init(id: predefinedPlanID,
              name: "Predefined \(name)",
              ester: self,
              frequency: defaultRhythm,
              dosage: defaultDose,
              visible: true,
              editable: false)
    }
}

// MARK: - Private Helper

private extension Ester {
    private var planIndex: UInt8 {
        switch self {
        case .enanthate: 0x01
        case .valerate: 0x02
        }
    }
}

// MARK: - Helper

extension Ester {
    /// Builds a stable sentinel UUID for a predefined plan from a single-byte index.
    ///
    /// - Note: The first four bytes spell `E5715AE1` ("ESTER+AE1") as a
    ///   recognizable prefix, the middle is filled with `0xEE`, and the last
    ///   byte carries the index. The version/variant nibbles land on `E`,
    ///   which is not a valid random (v4) UUID layout, so `UUID()`-generated
    ///   IDs for custom plans cannot collide with these values. Reserve a
    ///   unique `index` per predefined plan.
    var predefinedPlanID: UUID {
        .init(
            uuid: (0xE5, 0x71, 0x5A, 0xE1, 0xEE, 0xEE, 0xEE, 0xEE,
                   0xEE, 0xEE, 0xEE, 0xEE, 0xEE, 0xEE, 0xEE, planIndex)
        )
    }
}

