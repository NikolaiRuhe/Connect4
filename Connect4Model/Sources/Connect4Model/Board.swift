import Foundation

/// A `Board` contains positions of two players' pieces.
public struct Board: Equatable {
    public var oddPlayerGrid: Grid
    public var evenPlayerGrid: Grid

    public init(_ oddPlayerGrid: Grid = .empty, _ evenPlayerGrid: Grid = .empty) {
        self.oddPlayerGrid = oddPlayerGrid
        self.evenPlayerGrid = evenPlayerGrid
    }
}


extension Board: CustomStringConvertible {
    static let example = Self(Grid(0xa360315260000), Grid(0x509002a190301))

    public subscript(_ pos: Pos) -> Player? {
        oddPlayerGrid[pos] ? .odd : evenPlayerGrid[pos] ? .even : nil
    }

    public var combined: Grid { oddPlayerGrid.union(evenPlayerGrid) }

    mutating func with<T>(_ player: Player, _ body: (inout Grid) -> T) -> T {
        switch player {
        case .odd: return body(&oddPlayerGrid)
        case .even: return body(&evenPlayerGrid)
        }
    }

    public func dropPos(atCol col: Int) -> Pos? {
        combined.dropPos(atCol: col)
    }

    public var description: String {
        Pos.rowIndices.map { rowIndex in
            Pos.colIndices.map { colIndex in
                let pos = Pos(row: rowIndex, col: colIndex)
                if oddPlayerGrid[pos]  { return "🟡" }
                if evenPlayerGrid[pos] { return "🔴" }
                return "⚪️"
            }.joined()
        }.reversed().joined(separator: "\n")
    }

    public init?(_ string: String) {
        guard let oddPlayerGrid  = Grid(string, specialCharacter: "🟡") else { return nil }
        guard let evenPlayerGrid = Grid(string, specialCharacter: "🔴") else { return nil }
        self.oddPlayerGrid  = oddPlayerGrid
        self.evenPlayerGrid = evenPlayerGrid
    }
}
