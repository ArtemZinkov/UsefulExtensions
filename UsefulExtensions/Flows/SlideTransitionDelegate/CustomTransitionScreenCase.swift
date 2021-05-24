import CoreGraphics

enum CustomTransitionScreenCase {
    case rate
    case feedback
    case email

    var height: CGFloat {
        switch self {
        case .rate:
            return 310
        case .feedback:
            return 452
        case .email:
            return 370
        }
    }
}
