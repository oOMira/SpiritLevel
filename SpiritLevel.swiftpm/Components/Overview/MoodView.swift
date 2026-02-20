import SwiftUI
import WebKit


/// Hint: This struct is AI generated
struct MoodView: View {
    let mood: Mood
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
                    .controlSize(.large)
            }
            
            GIFView(mood: mood, isLoading: $isLoading)
                .opacity(isLoading ? 0 : 1)
        }
        .animation(.easeInOut(duration: 0.3), value: isLoading)
    }
}

/// Hint: This struct is AI generated
private struct GIFView: UIViewRepresentable {
    let mood: Mood
    @Binding var isLoading: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        webview.backgroundColor = .clear
        webview.isOpaque = false
        webview.scrollView.backgroundColor = .clear
        webview.navigationDelegate = context.coordinator
        
        // Load GIF on background thread
        Task {
            guard let url = Bundle.main.url(forResource: mood.imageName, withExtension: "gif") else {
                await MainActor.run {
                    isLoading = false
                }
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                await MainActor.run {
                    webview.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                }
            }
        }
        
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No need to reload on update
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isLoading: $isLoading)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var isLoading: Bool
        
        init(isLoading: Binding<Bool>) {
            _isLoading = isLoading
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            isLoading = false
        }
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
