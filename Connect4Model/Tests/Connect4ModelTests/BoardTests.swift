import XCTest
@testable import Connect4Model

final class BoardTests: XCTestCase {
    static let testBoardString = """
        ⚪️⚪️⚪️🟡⚪️⚪️⚪️
        ⚪️⚪️⚪️🔴⚪️⚪️⚪️
        ⚪️⚪️🔴🟡⚪️⚪️⚪️
        ⚪️⚪️🔴🔴🟡⚪️⚪️
        🔴🟡🔴🟡🟡🔴⚪️
        🟡🟡🔴🟡🔴🟡🔴
        """

    static let testBoard = Board(testBoardString)!

    func testBoardDescription() throws {
        XCTAssertEqual(Self.testBoard.description, Self.testBoardString)
    }

    func testDropPos() throws {
        let sut = Self.testBoard
        XCTAssertEqual(sut.dropPos(atCol: 0)?.row, 2)
        XCTAssertEqual(sut.dropPos(atCol: 1)?.row, 2)
        XCTAssertEqual(sut.dropPos(atCol: 2)?.row, 4)
        XCTAssertEqual(sut.dropPos(atCol: 3)?.row, nil)
        XCTAssertEqual(sut.dropPos(atCol: 4)?.row, 3)
        XCTAssertEqual(sut.dropPos(atCol: 5)?.row, 2)
        XCTAssertEqual(sut.dropPos(atCol: 6)?.row, 1)
    }
}
