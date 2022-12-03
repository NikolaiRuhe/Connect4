import Foundation

/// A `Grid` is a 7 x 6 binary matrix. Its cells contain boolean values,
/// where `true` represents a player's piece and `false` represents an
/// unoccupied cell.
///
///                           ┌─┬─┬─┬─┬─┬─┬─┐rows
///                           ├─┼─┼─┼─┼─┼─┼─┤`5
///                           ├─┼─┼─┼─┼─┼─┼─┤`4
///                           ├─┼─┼─┼─┼─┼─┼─┤`3
///                           ├─┼─┼─┼─┼─┼─┼─┤`2
///                           ├─┼─┼─┼─┼─┼─┼─┤`1
///                           └─┴─┴─┴─┴─┴─┴─┘`0
///                   columns  0 1 2 3 4 5 6

public struct Grid: Equatable, Hashable {
    // We only have 42 positions. These fit comfortably in a 64 bit word.
    // Column contents are represented by consecutive bits, where bit 0
    // contains row 0, col 0. Each column is represented by eight bits, two of
    // which are not used.
    var data: UInt64 = 0

    public init() { self.data = 0 }
    public init(_ data: UInt64 = 0) { self.data = data }

    /// A Grid where no position is occupied.
    public static let empty = Self(0)

    /// A Grid where every position is occupied. The bit mask represents all
    /// valid grid positions. It can be used to mask out invalid cells after a
    /// shift operation.
    public static let full = Self(.fullGridMask)
}

// A `Grid` is a sequence of `Pos` elements which represent the occupied
// positions in the grid.
extension Grid: Collection, IteratorProtocol {
    public mutating func next() -> Pos? {
        guard !isEmpty else { return nil }
        let pos = Pos(bit: data.trailingZeroBitCount)
        self[pos] = false
        return pos
    }

    public var isEmpty: Bool { data == 0 }
    public var count: Int { data.nonzeroBitCount }

    public func index(after index: Int) -> Int {
        guard index != UInt64.bitWidth else { return UInt64.bitWidth }
        let data = self.data &>> (index + 1)
        guard data != 0 else { return UInt64.bitWidth }
        return index + 1 + data.trailingZeroBitCount
    }

    public var startIndex: Int { data.trailingZeroBitCount }
    public var endIndex: Int { UInt64.bitWidth }

    public subscript(index: Int) -> Pos {
        let pos = Pos(bit: index)
        assert(self[pos])
        return pos
    }
}

extension Grid: RawRepresentable, CustomStringConvertible {
    public init?(rawValue: UInt64) {
        if rawValue & ~.fullGridMask != 0 { return nil }
        self.data = rawValue
    }

    public var rawValue: UInt64 { data }

    public subscript(_ pos: Pos) -> Bool {
        get { (data & pos.mask) != 0 }
        set {
            if newValue {
                data |= pos.mask
            } else {
                data &= ~pos.mask
            }
        }
    }

    private subscript(col col: Int) -> UInt8 {
        UInt8((data >> (col << 3)) & 0x3f)
    }

    public func dropPos(atCol col: Int) -> Pos? {
        switch self[col: col] {
        case 0x00: return Pos(row: 0, col: col)
        case 0x01: return Pos(row: 1, col: col)
        case 0x03: return Pos(row: 2, col: col)
        case 0x07: return Pos(row: 3, col: col)
        case 0x0f: return Pos(row: 4, col: col)
        case 0x1f: return Pos(row: 5, col: col)
        case 0x3f: return nil // column is full
        default:   return nil // invalid
        }
    }

    enum ShiftDirection: Int {
        case right     = 8
        case up        = 1
        case upRight   = 9
        case downRight = 7
    }

    mutating func shift(_ direction: ShiftDirection) {
        data = data &>> direction.rawValue
    }

    mutating func unShift(_ direction: ShiftDirection) {
        data = data &<< direction.rawValue
    }

    func shifted(_ direction: ShiftDirection, distance: Int) -> Self {
        .init(data &>> (direction.rawValue * distance))
    }

    func unShifted(_ direction: ShiftDirection) -> Self {
        .init(data &<< direction.rawValue)
    }

    public var isWin: Bool {
        let grid = containsFourAdjacent(direction: .right)
            .union(containsFourAdjacent(direction: .up))
            .union(containsFourAdjacent(direction: .upRight))
            .union(containsFourAdjacent(direction: .downRight))
        return grid.isEmpty == false
    }

    fileprivate func containsFourAdjacent(direction: ShiftDirection) -> Self {
        let two = self.shifted(direction, distance: 1).intersection(self)
        return two.shifted(direction, distance: 2).intersection(two)
    }

    func findFours() -> Self? {
        var result = findFours(direction: .right)
        guard result.isEmpty else { return result }
        result = findFours(direction: .up)
        guard result.isEmpty else { return result }
        result = findFours(direction: .upRight)
        guard result.isEmpty else { return result }
        result = findFours(direction: .downRight)
        guard result.isEmpty else { return result }
        return nil
    }

    func findFours(direction: ShiftDirection) -> Self {
        var grid = self
        var combined = grid
        if combined.isEmpty { return .empty }
        grid.shift(direction)
        combined.formIntersection(grid)
        if combined.isEmpty { return .empty }
        grid.shift(direction)
        combined.formIntersection(grid)
        if combined.isEmpty { return .empty }
        grid.shift(direction)
        combined.formIntersection(grid)
        if combined.isEmpty { return .empty }

        // four in a row detected
        grid = Self(combined)
        grid.unShift(direction)
        combined.formUnion(grid)
        grid.unShift(direction)
        combined.formUnion(grid)
        grid.unShift(direction)
        combined.formUnion(grid)
        return Self(combined)
    }

    public init?(_ string: String, specialCharacter: Character = "O") {
        let rows = string.split(separator: "\n")
        guard rows.count == 6 else { return nil }
        guard rows.allSatisfy( { $0.count == 7 } ) else { return nil }
        self.data = rows.reduce(0) { (data: UInt64, row: Substring) in
            (data << 1) | row.reversed().reduce(0) { (mask: UInt64, character: Character) in
                (mask << 8) | (character == specialCharacter ? 1 : 0)
            }
        }
    }

    public var description: String {
        Pos.rowIndices.map { rowIndex in
            Pos.colIndices.map { colIndex in
                self[Pos(row: rowIndex, col: colIndex)] ? "O" : "·"
            }.joined()
        }.reversed().joined(separator: "\n")
    }

    public var shortDescription: String {
        String(format: "0x%llx", data)
    }
}


extension Grid: SetAlgebra {
    public func contains(_ member: Pos) -> Bool {
        self[member]
    }

    public func union(_ other: Grid) -> Grid {
        Grid(self.data | other.data)
    }

    public func intersection(_ other: Grid) -> Grid {
        Grid(self.data & other.data)
    }

    public func symmetricDifference(_ other: Grid) -> Grid {
        Grid(self.data ^ other.data)
    }

    public mutating func insert(_ newMember: Pos) -> (inserted: Bool, memberAfterInsert: Pos) {
        defer { self[newMember] = true }
        return (!self[newMember], newMember)
    }

    public mutating func remove(_ member: Pos) -> Pos? {
        defer { self[member] = false }
        return self[member] ? member : nil
    }

    public mutating func update(with newMember: Pos) -> Pos? {
        defer { self[newMember] = true }
        return self[newMember] ? newMember : nil
    }

    public mutating func formUnion(_ other: Grid) {
        data |= other.data
    }

    public mutating func formIntersection(_ other: Grid) {
        data &= other.data
    }

    public mutating func formSymmetricDifference(_ other: Grid) {
        data ^= other.data
    }
}


fileprivate extension UInt64 {
    static let fullGridMask: Self = 0x003f3f3f3f3f3f3f
}
