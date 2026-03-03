import SwiftUI
import WebKit

// TODO: Replace with dotlottie (I don't know why but my designer friends love it)
// Should be there to test out if people like the idea of giving a rough estimate of your mental state based on hormone levels
// This is not scientific and should be fun. So (based on feedback), this might be a placeholder
struct MoodView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    private(set) var page: WebPage = .init()
    let mood: Mood

    var body: some View {
        WebView(page)
            .onAppear { loadGif(isStatic: reduceMotion) }
            .onDisappear { loadBlank() }
            .webViewContentBackground(.hidden)
            .webViewTextSelection(.disabled)
            .onChange(of: reduceMotion) { loadGif(isStatic: reduceMotion) }
            .onChange(of: mood) { loadGif(isStatic: reduceMotion) }
    }
    
    func loadGif(isStatic: Bool) {
        let resourceName = mood.getResourceName(isStatic: isStatic)
        guard let resourceUrl = Bundle.main.url(forResource: resourceName,
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
        case .happy: return isStatic ? "staticsmileycat" : "smileycat"
        case .sad: return isStatic ? "staticsadcat" : "sadcat"
        case .unclear: return isStatic ? "staticsmilecat" : "smilecat"
        }
    }
}
