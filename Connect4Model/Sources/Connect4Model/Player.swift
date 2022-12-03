import Foundation

public enum Player: CustomStringConvertible {
    case odd
    case even

    public func other() -> Player {
        switch self {
        case .odd: return .even
        case .even: return .odd
        }
    }

    public var description: String {
        switch self {
        case .odd:  return "🟡"
        case .even: return "🔴"
        }
    }
}
