import SwiftUI
import WebKit
import RegexBuilder

struct MoodView: View {
    @StateObject private var model: MoodViewModel

    init(mood: Mood) {
        _model = StateObject(wrappedValue: MoodViewModel(mood: mood))
    }

    var body: some View {
        WebView(model.page)
            .onAppear { model.loadGif() }
            .onDisappear { model.loadBlank() }
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

    func loadGif() {
        guard let resourceUrl = Bundle.module.url(forResource: "smilecat",
                                                  withExtension: .gifExtension),
              let data = try? Data(contentsOf: resourceUrl) else { return }
        page.load(data,
                  mimeType: .gifMimeType,
                  characterEncoding: .utf8,
                  baseURL: resourceUrl.deletingLastPathComponent())
    }

    // TODO: load from File
    func loadBlank() {
        let emptyHTML = "<html><body></body></html>"
        page.load(html: emptyHTML, baseURL: .init(string: "about:blank")!)
    }
}

// MARK: - Constants

private extension String {
    static let gifExtension = "gif"
    static let gifMimeType = "image/gif"
}
