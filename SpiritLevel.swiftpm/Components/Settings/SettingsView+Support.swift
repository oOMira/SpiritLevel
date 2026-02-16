import SwiftUI

struct SupportSection: View {
    var body: some View {
        Group {
            let configurations: [SupportSection.Cell.Configuration] = [
                .init(url: .githubURL!, title: .githubTitle),
                .init(url: .inspirationURL!, title: .inspirationTitle),
                .init(url: .feedbackURL!, title: .feedbackTitle)
            ]
            
            ForEach(configurations) { configuration in
                Cell(configuration: configuration)
            }
        }
    }
}

extension SupportSection {
    struct Cell: View {
        let configuration: Configuration
        
        var body: some View {
            Link(destination: configuration.url) {
                HStack {
                    Text(configuration.title)
                    Spacer()
                    Image(systemName: .externalLinkSystemImage)
                }
            }
        }
    }
}

extension SupportSection.Cell {
    struct Configuration: Identifiable {
        let id = UUID()
        
        let url: URL
        let title: LocalizedStringKey
    }
}

// MARK: - Constants

private extension URL {
    static let githubURL = URL(string: "https://github.com")
    static let inspirationURL = URL(string: "https://github.com/tiliaqt/transkit")
    static let feedbackURL = URL(string: "mailto:feedback@example.com")
    
}

@MainActor
private extension LocalizedStringKey {
    static let githubTitle: Self = "GitHub"
    static let inspirationTitle: Self = "Inspiration"
    static let feedbackTitle: Self = "Feedback"
}

private extension String {
    static let externalLinkSystemImage: Self = "square.and.arrow.up"
}

#Preview {
    SupportSection()
}
