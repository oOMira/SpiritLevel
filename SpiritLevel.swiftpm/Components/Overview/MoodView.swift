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
        .animation(.easeInOut(duration: .animationDuration), value: isLoading)
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
            guard let url = Bundle.main.url(forResource: mood.imageName, withExtension: .gifExtension) else {
                await MainActor.run {
                    isLoading = false
                }
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                await MainActor.run {
                    webview.load(data, mimeType: .gifMimeType, characterEncodingName: .utf8Encoding, baseURL: url.deletingLastPathComponent())
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

// MARK: - Constants

private extension Mood {
    var imageName: String {
        switch self {
        case .happy: return .happyImageName
        case .sad: return .sadImageName
        }
    }
}

private extension String {
    static let happyImageName = "smileCat"
    static let sadImageName = "sadCat"
    static let gifExtension = "gif"
    static let gifMimeType = "image/gif"
    static let utf8Encoding = "UTF-8"
}

private extension Double {
    static let animationDuration: Self = 0.3
}

// MARK: - Preview

#Preview("Happy - Light Mode") {
    MoodView(mood: .happy)
        .frame(width: 200, height: 200)
        .preferredColorScheme(.light)
}

#Preview("Happy - Dark Mode") {
    MoodView(mood: .happy)
        .frame(width: 200, height: 200)
        .preferredColorScheme(.dark)
}

#Preview("Sad - Light Mode") {
    MoodView(mood: .sad)
        .frame(width: 200, height: 200)
        .preferredColorScheme(.light)
}

#Preview("Sad - Dark Mode") {
    MoodView(mood: .sad)
        .frame(width: 200, height: 200)
        .preferredColorScheme(.dark)
}
