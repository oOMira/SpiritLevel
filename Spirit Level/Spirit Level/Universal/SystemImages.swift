import SwiftUI

enum SystemImage: String, CaseIterable {
    case chevronForward = "chevron.forward"
    case calendar = "calendar"
}

extension SystemImage {
    var image: Image { .init(systemName: rawValue) }
    var name: String { rawValue }
}
        
extension String {
    typealias systemImage = SystemImage
}
