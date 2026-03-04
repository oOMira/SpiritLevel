import SwiftUI

struct AcknowledgementView: View {
    private let configuration: Configuration

    init(acknowledgment: Acknowledgment) {
        self.configuration = acknowledgment.configuration
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(configuration.name)
                        .font(.headline)
                    Text(configuration.copyrightText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(configuration.licenceText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Link(destination: configuration.sourceLink) {
                        Text(configuration.sourceLink.absoluteString)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                
                Divider()
                
                Text(configuration.fullText)
                    .font(.system(.caption, design: .monospaced))
                    .contentShape(.accessibility, RoundedRectangle(cornerRadius: 8))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Acknowledgement")
    }
}

extension AcknowledgementView {
    struct Configuration: Identifiable {
        let id = UUID()
        let name: String
        let copyrightText: String
        let licenceText: String
        let sourceLink: URL
        let fullLicenceURL: URL
        let fullText: String

        init(name: String,
             copyrightText: String,
             licenceText: String,
             licenceLink: URL,
             fullLicenceURL: URL) {
            self.name = name
            self.copyrightText = copyrightText
            self.licenceText = licenceText
            self.sourceLink = licenceLink
            self.fullLicenceURL = fullLicenceURL
            do {
                self.fullText = try String(contentsOf: fullLicenceURL, encoding: .utf8)
            } catch {
                self.fullText = "Could not resolve \(fullLicenceURL.absoluteString). Check out directly for more information."
            }
        }
    }
}
