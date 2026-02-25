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
    
    var imageDescription: String {
        switch self {
        case .sStreak:          "A stack of colorful books on a wooden surface"
        case .mStreak:          "A cute orange cat wearing glasses and a suit, holding books while standing in front of a chalkboard"
        case .lStreak:          "A hand holding up a graduation cap against a sky background with trees"
        case .sTime:            "A pink chronograph watch with a leather strap against a pink background with green leaves"
        case .mTime:            "A desk calendar showing a month view with some dates highlighted in pink"
        case .lTime:            "Colorful fireworks bursting in a night sky"
        case .xlTime:           "A pink rocking chair on a wooden porch with a scenic outdoor view"
        case .firstInjection:   "A medical vial with a blue cap and colorful label on a purple and pink background"
        case .sInjection:       "A single syringe with blue liquid on a coral pink background"
        case .mInjection:       "Three syringes standing upright with blue liquid and measurement markings, on a surface with plants"
        case .lInjection:       "A yellow sharps disposal container with a biohazard symbol and SHARPS label"
        case .firstLab:         "A light blue and gray stethoscope on a pale background"
        case .sLab:             "A healthcare professional in a white coat with a stethoscope, sitting at a desk writing in a notebook"
        case .mLab:             "A red and white ambulance or emergency medical vehicle in front of residential buildings"
        case .lLab:             "A white hospital building with a red cross symbol on the front, featuring multiple windows and a grand entrance"
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
