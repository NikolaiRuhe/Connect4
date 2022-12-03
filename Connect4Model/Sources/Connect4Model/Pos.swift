import Foundation


/// A position denoting row and column indices in the grid.
/// Pos values are always in range. No positions outside of the valid grid
/// area can be formed.
public struct Pos: Equatable, Hashable {
    /// The bit number in a UInt64 representing the position in the grid.
    var bit: Int

    public init(row: Int, col: Int) {
        assert(Self.rowIndices.contains(row))
        assert(Self.colIndices.contains(col))
        bit = col &<< 3 | row
    }

    public init(bit: Int) {
        self.bit = bit
    }
}


extension Pos: Comparable {
    public static func < (lhs: Pos, rhs: Pos) -> Bool {
        lhs.bit < rhs.bit
    }
}

extension Pos: CaseIterable {
    public static let allCases = Grid.full

    public static let rowIndices = 0 ..< 6
    public static let colIndices = 0 ..< 7

    public static let rowCount = rowIndices.count
    public static let colCount = colIndices.count
}


extension Pos: Identifiable, CustomStringConvertible {

    public var description: String {
        "[row: \(row), col: \(col)]"
    }

    public var id: Int { bit }

    public var row: Int {
        get { bit & 7 }
        set {
            assert(Self.rowIndices.contains(newValue))
            bit = newValue | col &<< 3
        }
    }

    public var col: Int {
        get { bit &>> 3 }
        set {
            assert(Self.colIndices.contains(newValue))
            bit = newValue &<< 3 | row
        }
    }

    internal var mask: UInt64 { UInt64(1 &<< bit) }
}
