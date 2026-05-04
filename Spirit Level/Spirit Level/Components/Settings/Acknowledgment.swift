import Foundation

enum Acknowledgment: String, CaseIterable, Hashable, Identifiable {
    var id: String { rawValue }

    case lottie
    case animatedEmojis
}

extension Acknowledgment {
    var configuration: AcknowledgmentView.Configuration {
        switch self {
        case .animatedEmojis:
            .init(
                name: "Noto Emoji Animation",
                copyrightText: "Copyright 2020 Google LLC",
                licenseText: "Licensed under the Creative Commons Attribution 4.0 International License",
                licenseLink: URL(string: "https://googlefonts.github.io/noto-emoji-animation/")!,
                fullLicenseURL: Bundle.main.url(forResource: "emojilicense", withExtension: "txt")!
            )
        case .lottie:
            .init(
                name: "Lottie for Swift",
                copyrightText: "Copyright 2018 Airbnb, Inc.",
                licenseText: "Licensed under the Apache License, Version 2.0",
                licenseLink: URL(string: "https://github.com/airbnb/lottie-spm")!,
                fullLicenseURL: Bundle.main.url(forResource: "lottielicense", withExtension: "txt")!
            )
        }
    }
}
