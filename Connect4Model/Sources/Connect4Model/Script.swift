import Foundation


/// A type that stores both player's moves in a game, up to 42 moves.
public struct Script: Equatable {
    var data: (UInt64, UInt64)

    public init(_ moves0: UInt64 = 0, _ moves1: UInt64 = 0) {
        self.data = (moves0, moves1)
    }

    public struct Move {
        var index: Int
        var col: Int
        var player: Player { index.isMultiple(of: 2) ? .even : .odd }
    }

    public static func == (lhs: Script, rhs: Script) -> Bool {
        lhs.data.0 == rhs.data.0 && lhs.data.1 == rhs.data.1
    }

    static let example = Self(0o444443323356616663346, 0o777725)
}


extension Script: Sequence {
    public var startIndex: Int { 0 }
    public var endIndex: Int {
        data.1 == 0
        ? data.0.octalDigitCount
        : data.1.octalDigitCount + 21
    }
    public var count: Int { endIndex - startIndex }

    /// The player that will perform the next turn.
    public var player: Player { count.isMultiple(of: 2) ? .odd : .even }

    public mutating func append(col: Int) {
        if data.0.octalDigitCount == 21 {
            data.1 = (data.1 &<< 3) | UInt64(col + 1)
        } else {
            data.0 = (data.0 &<< 3) | UInt64(col + 1)
        }
    }

    public mutating func pop() -> Int? {
        if data.1 != 0 {
            defer { data.1 &>>= 3 }
            return Int(data.1 & 0o7) - 1
        } else if data.0 != 0 {
            defer { data.0 &>>= 3 }
            return Int(data.0 & 0o7) - 1
        } else {
            return nil
        }
    }

    public func makeIterator() -> ScriptIterator { ScriptIterator(self) }

    public struct ScriptIterator: IteratorProtocol {
        private var data: (UInt64, UInt64)
        private var index: Int = 0
        fileprivate init(_ script: Script) { self.data = script.data }
        public mutating func next() -> Move? {
            let col = data.0 != 0
                ? data.0.extractCol()
                : data.1.extractCol()
            guard let col else { return nil }
            index += 1
            return Move(
                index: index,
                col: col
            )
        }
    }
}


extension UInt64 {
    var octalDigitCount: Int {
        (Self.bitWidth - leadingZeroBitCount + 2) / 3
    }

    mutating func extractCol() -> Int? {
        if self == 0 { return nil }
        let remainingDigits = octalDigitCount - 1
        let col = Int(self >> (3 * remainingDigits)) - 1
        self &= (1 << (3 * remainingDigits)) - 1
        return col
    }
}
