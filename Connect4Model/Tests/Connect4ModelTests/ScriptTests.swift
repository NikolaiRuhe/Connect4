import XCTest
@testable import Connect4Model

final class ScriptTests: XCTestCase {
    func testScriptAppend() throws {
        var sut = Script()
        XCTAssertEqual(sut.count, 0)
        sut.append(col: 3)
        XCTAssertEqual(sut.count, 1)
        sut.append(col: 3)
        XCTAssertEqual(sut.count, 2)
        sut.append(col: 2)
        XCTAssertEqual(sut.count, 3)
        sut.append(col: 1)
        XCTAssertEqual(sut.count, 4)
        sut.append(col: 0)
        XCTAssertEqual(sut.count, 5)
        sut.append(col: 6)
        XCTAssertEqual(sut.count, 6)
    }

    func testExampleScriptCount() throws {
        let sut = Script.example
        XCTAssertEqual(sut.count, 27)
    }

    func testExampleScriptContents() throws {
        var sut = Script.example.makeIterator()
        XCTAssertEqual(sut.next()!.col + 1, 4)
        XCTAssertEqual(sut.next()!.col + 1, 4)
        XCTAssertEqual(sut.next()!.col + 1, 4)
        XCTAssertEqual(sut.next()!.col + 1, 4)
        XCTAssertEqual(sut.next()!.col + 1, 4)
        XCTAssertEqual(sut.next()!.col + 1, 3)
        XCTAssertEqual(sut.next()!.col + 1, 3)
        XCTAssertEqual(sut.next()!.col + 1, 2)
        XCTAssertEqual(sut.next()!.col + 1, 3)
        XCTAssertEqual(sut.next()!.col + 1, 3)
        XCTAssertEqual(sut.next()!.col + 1, 5)
        XCTAssertEqual(sut.next()!.col + 1, 6)
        XCTAssertEqual(sut.next()!.col + 1, 6)
        XCTAssertEqual(sut.next()!.col + 1, 1)
        XCTAssertEqual(sut.next()!.col + 1, 6)
        XCTAssertEqual(sut.next()!.col + 1, 6)
        XCTAssertEqual(sut.next()!.col + 1, 6)
        XCTAssertEqual(sut.next()!.col + 1, 3)
        XCTAssertEqual(sut.next()!.col + 1, 3)
        XCTAssertEqual(sut.next()!.col + 1, 4)
        XCTAssertEqual(sut.next()!.col + 1, 6)
        XCTAssertEqual(sut.next()!.col + 1, 7)
        XCTAssertEqual(sut.next()!.col + 1, 7)
        XCTAssertEqual(sut.next()!.col + 1, 7)
        XCTAssertEqual(sut.next()!.col + 1, 7)
        XCTAssertEqual(sut.next()!.col + 1, 2)
        XCTAssertEqual(sut.next()!.col + 1, 5)
        XCTAssertNil(sut.next())
    }

    func testExampleScriptResult() throws {
        let game = Game(replayFrom: .example)
        XCTAssertEqual(game.board, Board.example)
    }
}
