import SwiftUI

enum SystemImage: String, CaseIterable {
    case chevronForward = "chevron.forward"
}

extension SystemImage {
    var image: Image { .init(systemName: rawValue) }
    var name: String { rawValue }
}
        
extension String {
    typealias systemImage = SystemImage
}
