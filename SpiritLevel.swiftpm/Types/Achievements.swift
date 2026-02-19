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

extension Achievement {
    var name: String {
        switch self {
        case .sStreak:          "Short Streak"
        case .mStreak:          "Mid Streak"
        case .lStreak:          "Long Streak"
        case .sTime:            "Getting Started"
        case .mTime:            "Keeping It Going"
        case .lTime:            "Staying Consistent"
        case .xlTime:           "Long-Term Commitment"
        case .firstInjection:   "First Injection"
        case .sInjection:       "Injection Milestone I"
        case .mInjection:       "Injection Milestone II"
        case .lInjection:       "Injection Milestone III"
        case .firstLab:         "First Lab Result"
        case .sLab:             "Lab Milestone I"
        case .mLab:             "Lab Milestone II"
        case .lLab:             "Lab Milestone III"
        }
    }
}


extension Achievement {
    var description: String {
        switch self {
        case .sStreak:          "Log 5 injections on time"
        case .mStreak:          "Log 10 injections on time"
        case .lStreak:          "Log 25 injections on time"
        case .sTime:            "Get started with the app"
        case .mTime:            "Use the app for six months"
        case .lTime:            "Use the app for one year"
        case .xlTime:           "Use the app for two years"
        case .firstInjection:   "Log your first injection"
        case .sInjection:       "Log 10 injections"
        case .mInjection:       "Log 25 injections"
        case .lInjection:       "Log 50 injections"
        case .firstLab:         "Log your first lab result"
        case .sLab:             "Log 5 lab results"
        case .mLab:             "Log 10 lab results"
        case .lLab:             "Log 15 lab results"
        }
    }
}
