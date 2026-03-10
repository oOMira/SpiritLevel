import SwiftUI

struct AcknowledgementView: View {
    let configuration: Configuration
    
    var body: some View {
        let rectangle = RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .inset(by: -4)
        ScrollView {
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
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .contentShape(.accessibility, rectangle)
            .accessibilityElement(children: .combine)
            
            Divider()
            
            Text(configuration.fullText)
                .font(.system(.caption, design: .monospaced))
                .contentShape(.accessibility, rectangle)
                .padding()
        }
    }
}

extension AcknowledgementView {
    struct Configuration: Identifiable {
        let id = UUID()
        let name: String
        let copyrightText: String
        let licenceText: String
        let sourceLink: URL
        let fulllLicenceURL: URL
        let fullText: String
        
        init(name: String,
             copyrightText: String,
             licenceText: String,
             licenceLink: URL,
             fulllLicenceURL: URL) {
            self.name = name
            self.copyrightText = copyrightText
            self.licenceText = licenceText
            self.sourceLink = licenceLink
            self.fulllLicenceURL = fulllLicenceURL
            do {
                self.fullText = try String(contentsOf: fulllLicenceURL, encoding: .utf8)
            } catch {
                self.fullText = "Could not resolve \(fulllLicenceURL.absoluteString). Check out directly for more information."
            }
        }
    }
}


extension AcknowledgementView.Configuration {
    static let lottie: Self = .init(name: "Lottie for Swift",
                                    copyrightText: "Copyright 2018 Airbnb, Inc.",
                                    licenceText: "Licensed under the Apache License, Version 2.0",
                                    licenceLink: URL(string: "https://github.com/airbnb/lottie-spm")!,
                                    fulllLicenceURL: Bundle.main.url(forResource: "lottielicence", withExtension: "txt")!)
    
    static let emojis: Self = .init(name: "Noto Emoji Animation",
                                    copyrightText: "Copyright 2020 Google LLC",
                                    licenceText: "Licensed under the Creative Commons Attribution 4.0 International License",
                                    licenceLink: URL(string: "https://googlefonts.github.io/noto-emoji-animation/")!,
                                    fulllLicenceURL: Bundle.main.url(forResource: "emojilicence", withExtension: "txt")!)
}
