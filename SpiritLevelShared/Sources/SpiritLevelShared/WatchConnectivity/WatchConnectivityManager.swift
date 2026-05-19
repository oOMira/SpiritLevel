import Foundation
import SwiftData
import WatchConnectivity
import OSLog

@MainActor
public final class WatchConnectivityManager: NSObject {
    private let modelContext: ModelContext
    private let session: WCSession
    private var isProcessingRemoteData = false

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.session = WCSession.default
        super.init()

        guard WCSession.isSupported() else {
            Logger.app.warning("WCSession is not supported")
            return
        }
        session.delegate = self
        session.activate()
        observeLocalChanges()
    }

    private func observeLocalChanges() {
        Task { [weak self] in
            for await _ in NotificationCenter.default.notifications(named: ModelContext.didSave) {
                guard let self, !self.isProcessingRemoteData else { continue }
                self.sendCurrentData()
            }
        }
    }

    private func sendCurrentData() {
        guard session.activationState == .activated else { return }

        do {
            let injections = try modelContext.fetch(FetchDescriptor<Injection>())
            let labResults = try modelContext.fetch(FetchDescriptor<LabResult>())
            let treatmentPlans = try modelContext.fetch(FetchDescriptor<TreatmentPlan>())

            let payload = SyncPayload(
                injections: injections.map(\.transferRepresentation),
                labResults: labResults.map(\.transferRepresentation),
                treatmentPlans: treatmentPlans.map(\.transferRepresentation)
            )

            let data = try JSONEncoder().encode(payload)
            try session.updateApplicationContext(["syncData": data])
            Logger.app.info("Sent sync data to counterpart")
        } catch {
            Logger.app.error("Failed to send sync data: \(error)")
        }
    }

    private func processReceivedData(_ data: Data) {
        do {
            let payload = try JSONDecoder().decode(SyncPayload.self, from: data)

            isProcessingRemoteData = true
            defer { isProcessingRemoteData = false }

            try mergePayload(payload)
            Logger.app.info("Merged sync data from counterpart")
        } catch {
            Logger.app.error("Failed to process sync data: \(error)")
        }
    }

    private func mergePayload(_ payload: SyncPayload) throws {
        let existingInjectionIDs = Set(try modelContext.fetch(FetchDescriptor<Injection>()).map(\.id))
        for transfer in payload.injections where !existingInjectionIDs.contains(transfer.id) {
            let injection = Injection(ester: transfer.ester, dosage: transfer.dosage, date: transfer.date)
            injection.id = transfer.id
            modelContext.insert(injection)
        }

        let existingLabResultIDs = Set(try modelContext.fetch(FetchDescriptor<LabResult>()).map(\.id))
        for transfer in payload.labResults where !existingLabResultIDs.contains(transfer.id) {
            let labResult = LabResult(concentration: transfer.concentration, date: transfer.date)
            labResult.id = transfer.id
            modelContext.insert(labResult)
        }

        let existingPlanIDs = Set(try modelContext.fetch(FetchDescriptor<TreatmentPlan>()).map(\.id))
        for transfer in payload.treatmentPlans where !existingPlanIDs.contains(transfer.id) {
            let plan = TreatmentPlan(
                name: transfer.name,
                ester: transfer.ester,
                frequency: transfer.frequency,
                dosage: transfer.dosage,
                firstInjectionDate: transfer.firstInjectionDate
            )
            plan.id = transfer.id
            modelContext.insert(plan)
        }

        guard modelContext.hasChanges else { return }
        try modelContext.save()
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    public nonisolated func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        if let error {
            Logger.app.error("WCSession activation failed: \(error)")
            return
        }

        guard let data = session.receivedApplicationContext["syncData"] as? Data else { return }
        
        Task { @MainActor [weak self, data] in
            self?.processReceivedData(data)
        }

        Task { @MainActor [weak self] in
            self?.sendCurrentData()
        }
    }

    public nonisolated func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String: Any]
    ) {
        guard let data = applicationContext["syncData"] as? Data else { return }

        Task { @MainActor [weak self, data] in
            self?.processReceivedData(data)
        }
    }

    #if os(iOS)
    public nonisolated func sessionDidBecomeInactive(_ session: WCSession) {}

    public nonisolated func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif
}
