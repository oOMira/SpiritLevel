import SwiftUI
import WebKit

struct MoodView: View {
    @StateObject private var model: MoodViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(mood: Mood) {
        _model = StateObject(wrappedValue: MoodViewModel(mood: mood))
    }

    var body: some View {
        WebView(model.page)
            .onAppear { model.loadGif(isStatic: reduceMotion) }
            .onDisappear { model.loadBlank() }
            .webViewContentBackground(.hidden)
            .webViewTextSelection(.disabled)
            .onChange(of: reduceMotion) { model.loadGif(isStatic: reduceMotion) }
    }
}

// MARK: - ViewModel

@MainActor
final class MoodViewModel: ObservableObject {
    private(set) var page: WebPage
    @Published var mood: Mood

    init(mood: Mood) {
        self.mood = mood
        self.page = .init()
    }

    func loadGif(isStatic: Bool) {
        let resourceName = mood.getResourceName(isStatic: isStatic)
        guard let resourceUrl = Bundle.module.url(forResource: resourceName,
                                                  withExtension: .gifExtension),
              let data = try? Data(contentsOf: resourceUrl) else { return }
        
        let base64 = data.base64EncodedString()
        let html = String.gifHTML(base64Encoded: base64)
        
        page.load(html: html, baseURL: resourceUrl.deletingLastPathComponent())
    }

    func loadBlank() {
        page.load(html: .emptyHTML, baseURL: .init(string: "about:blank")!)
    }
}

// MARK: - Constants

private extension String {
    static let gifExtension = "gif"
    static let gifMimeType = "image/gif"
    
    static let emptyHTML = "<html><body style=\"background:transparent;\"></body></html>"
    
    static func gifHTML(base64Encoded base64: String) -> String {
        """
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
            <style>
                * { margin: 0; padding: 0; }
                html, body {
                    width: 100%;
                    height: 100%;
                    background: transparent;
                    overflow: hidden;
                    pointer-events: none;
                    user-select: none;
                    -webkit-user-select: none;
                    -webkit-touch-callout: none;
                }
                img {
                    width: 100%;
                    height: 100%;
                    object-fit: contain;
                }
            </style>
        </head>
        <body>
            <img src="data:image/gif;base64,\(base64)" />
        </body>
        </html>
        """
    }
}

private extension Mood {
    func getResourceName(isStatic: Bool = false) -> String {
        switch self {
        case .happy: return isStatic ? "smilecatstatic" : "smilecat"
        case .sad: return isStatic ? "sadcatstatic" : "sadsmilecat"
        }
    }
}
