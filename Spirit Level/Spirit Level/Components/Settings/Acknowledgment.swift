import Foundation

enum Acknowledgment: String, CaseIterable, Hashable, Identifiable {
    var id: String { rawValue }
    
    case lottie
    case animtadEmojis
}

extension Acknowledgment {
    var configuration: AcknowledgementView.Configuration {
        switch self {
        case .animtadEmojis: .init(name: "Noto Emoji Animation",
                                   copyrightText: "Copyright 2020 Google LLC",
                                   licenceText: "Licensed under the Creative Commons Attribution 4.0 International License",
                                   licenceLink: URL(string: "https://googlefonts.github.io/noto-emoji-animation/")!,
                                   fullLicenceURL: Bundle.main.url(forResource: "emojilicence", withExtension: "txt")!)
        case .lottie: .init(name: "Lottie for Swift",
                            copyrightText: "Copyright 2018 Airbnb, Inc.",
                            licenceText: "Licensed under the Apache License, Version 2.0",
                            licenceLink: URL(string: "https://github.com/airbnb/lottie-spm")!,
                            fullLicenceURL: Bundle.main.url(forResource: "lottielicence", withExtension: "txt")!)
        }
    }
}
