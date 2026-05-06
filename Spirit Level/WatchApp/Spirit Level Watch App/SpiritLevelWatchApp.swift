import SwiftUI
import SwiftData
import OSLog
import HealthDataLogging
import SpiritLevelShared

@main
struct SpiritLevelWatchApp: App {
    private let startupResult: Result<ModelContainer, Error>

    init() {
        startupResult = Self.makeStartupResult()
    }

    private static func makeStartupResult() -> Result<ModelContainer, Error> {
        do {
            let modelContainer = try SharedModelContainer.create()
            Logger.app.info("Watch app startup completed successfully")
            return .success(modelContainer)
        } catch {
            Logger.app.error("Watch app startup failed: \(error)")
            return .failure(error)
        }
    }

    var body: some Scene {
        WindowGroup {
            switch startupResult {
            case let .success(modelContainer):
                ContentView()
                    .modelContainer(modelContainer)
            case let .failure(error):
                AppLaunchErrorView(error: error)
            }
        }
    }
}

private struct AppLaunchErrorView: View {
    let error: Error

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.yellow)

                Text("Unable to Start App")
                    .font(.headline)

                Text("Couldn’t load data. Please restart the app.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                Text(error.localizedDescription)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
            .padding()
        }
    }
}
