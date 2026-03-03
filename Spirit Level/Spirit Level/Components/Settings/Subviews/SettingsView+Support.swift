import SwiftUI

struct SupportCellView: View {
    var body: some View {
        Group {
            let configurations: [SupportCellView.Cell.Configuration] = [
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

extension SupportCellView {
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

extension SupportCellView.Cell {
    struct Configuration: Identifiable {
        let id = UUID()
        
        let url: URL
        let title: LocalizedStringResource
    }
}

// MARK: - Constants

private extension URL {
    static let githubURL = URL(string: "https://github.com/oomira")
    static let inspirationURL = URL(string: "https://github.com/tiliaqt/transkit")
    static let feedbackURL = URL(string: "mailto:feedback@example.email")
    
}

private extension LocalizedStringResource {
    static let githubTitle: Self = "GitHub"
    static let inspirationTitle: Self = "Inspiration"
    static let feedbackTitle: Self = "Feedback"
}

private extension String {
    static let externalLinkSystemImage: Self = "square.and.arrow.up"
}

#Preview {
    SupportCellView()
}
