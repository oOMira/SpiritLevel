import SwiftUI

enum Achievement: String, Identifiable, CaseIterable {
    var id: String { rawValue }

    case sStreak
    case mStreak
    case lStreak
    case sTime
    case mTime
    case lTime
    case xlTime
    case firstInjection
    case sInjection
    case mInjection
    case lInjection
    case firstLab
    case sLab
    case mLab
    case lLab
}

extension Achievement {
    var image: Image { .init(imageName) }

    var imageName: String {
        switch self {
        case .sStreak:          "sStreak"
        case .mStreak:          "mStreak"
        case .lStreak:          "lStreak"
        case .sTime:            "sTime"
        case .mTime:            "mTime"
        case .lTime:            "lTime"
        case .xlTime:           "xlTime"
        case .firstInjection:   "firstInjection"
        case .sInjection:       "sInjection"
        case .mInjection:       "mInjection"
        case .lInjection:       "lInjection"
        case .firstLab:         "firstLab"
        case .sLab:             "sLab"
        case .mLab:             "mLab"
        case .lLab:             "lLab"
        }
    }
}
