import XCTest
@testable import Connect4Model

final class PosTests: XCTestCase {
    func testPosBitValue() throws {
        XCTAssertEqual(Pos(row: 0, col: 0).bit, 0)
        XCTAssertEqual(Pos(row: 1, col: 0).bit, 1)
        XCTAssertEqual(Pos(row: 0, col: 1).bit, 8)
        XCTAssertEqual(Pos(row: 5, col: 6).bit, 53)
    }

    func testAllCasesAreComplete() throws {
        let expected = Pos.colIndices.flatMap { col in
            Pos.rowIndices.map { Pos(row: $0, col: col) }
        }
        XCTAssertTrue(Pos.allCases.elementsEqual(expected))
    }

    func testComparable() throws {
        let pairs = zip(
            Pos.allCases.dropLast(),
            Pos.allCases.dropFirst()
        )
        XCTAssertTrue(pairs.allSatisfy { $0.0 < $0.1 } )
    }
}
