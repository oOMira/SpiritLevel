import SwiftUI

@main
struct MyApp: App {
    @State private var deepLinkTarget: (any SearchableItem)?

    var body: some Scene {
        WindowGroup {
            ContentView(deepLinkTarget: $deepLinkTarget)
                .onOpenURL { url in
                    guard url.scheme == "spiritlevel",
                          let host = url.host(),
                          let result = Content.resolve(rawValue: host)
                    else { return }
                    deepLinkTarget = result
                }
        }
    }
}
