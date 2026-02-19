import SwiftUI
import WebKit

struct MoodView: UIViewRepresentable {
    let mood: Mood
    
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        let url = Bundle.main.url(forResource: mood.imageName, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webview.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}

private extension Mood {
    var imageName: String {
        switch self {
        case .happy: return "smileCat"
        case .sad: return "sadCat"
        }
    }
}
