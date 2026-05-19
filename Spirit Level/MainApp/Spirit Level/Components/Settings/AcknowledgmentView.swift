import SwiftUI

struct AcknowledgmentView: View {
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
                    Text(configuration.licenseText)
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
        .navigationTitle("Acknowledgment")
    }
}

extension AcknowledgmentView {
    struct Configuration: Identifiable {
        let id = UUID()
        let name: String
        let copyrightText: String
        let licenseText: String
        let sourceLink: URL
        let fullLicenseURL: URL
        let fullText: String

        init(name: String,
             copyrightText: String,
             licenseText: String,
             licenseLink: URL,
             fullLicenseURL: URL) {
            self.name = name
            self.copyrightText = copyrightText
            self.licenseText = licenseText
            self.sourceLink = licenseLink
            self.fullLicenseURL = fullLicenseURL
            do {
                self.fullText = try String(contentsOf: fullLicenseURL, encoding: .utf8)
            } catch {
                self.fullText =
                    "Could not open \(fullLicenseURL.absoluteString). View it directly for more information."
            }
        }
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Light Mode") {
    NavigationStack {
        AcknowledgmentView(acknowledgment: .lottie)
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationStack {
        AcknowledgmentView(acknowledgment: .lottie)
    }
    .preferredColorScheme(.dark)
}
#endif
