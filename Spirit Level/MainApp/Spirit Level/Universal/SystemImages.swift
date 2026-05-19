import SwiftUI

enum SystemImage: String, CaseIterable {
    case chevronForward = "chevron.forward"
    case calendar = "calendar"
    case checkmarkCircle = "checkmark.circle"
    case xCircle = "x.circle"
    case photo = "photo"
}

extension SystemImage {
    var image: Image { .init(systemName: rawValue) }
    var name: String { rawValue }
}
