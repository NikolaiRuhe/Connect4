import XCTest
@testable import Connect4Model

final class GridTests: XCTestCase {
    static let testGrid = Grid("""
        ·······
        ·······
        ···O···
        ··OOO··
        ·O·O·O·
        OOOO··O
        """)!
    static let testGridIndices = [0, 8, 9, 16, 18, 24, 25, 26, 27, 34, 41, 48]

    func testFullCount() throws {
        XCTAssertEqual(Grid.full.data.nonzeroBitCount, 42)
    }

    func testGridInit() throws {
        let gridString = """
            ·······
            ·······
            ···O···
            ···O·O·
            ···O··O
            OOO···O
            """
        let sut = Grid(gridString)!
        XCTAssertEqual(sut.description, gridString)
    }

    func testFindFoursRight() throws {
        let result = Self.testGrid.findFours(direction: .right)
        XCTAssertEqual(result.description, """
            ·······
            ·······
            ·······
            ·······
            ·······
            OOOO···
            """)
    }

    func testFindFoursUp() throws {
        let result = Self.testGrid.findFours(direction: .up)
        XCTAssertEqual(result.description, """
            ·······
            ·······
            ···O···
            ···O···
            ···O···
            ···O···
            """)
    }

    func testFindFoursUpRight() throws {
        let result = Self.testGrid.findFours(direction: .upRight)
        XCTAssertEqual(result.description, """
            ·······
            ·······
            ···O···
            ··O····
            ·O·····
            O······
            """)
    }

    func testFindFoursDownRight() throws {
        let result = Self.testGrid.findFours(direction: .downRight)
        XCTAssertEqual(result.description, """
            ·······
            ·······
            ···O···
            ····O··
            ·····O·
            ······O
            """)
    }

    func testShifting() throws {
        let two = Self.testGrid.shifted(.up, distance: 1).intersection(Self.testGrid)
        XCTAssertEqual(two.description, """
            ·······
            ·······
            ·······
            ···O···
            ···O···
            ·O·O···
            """)
        let three = two.shifted(.up, distance: 1).intersection(two)
        XCTAssertEqual(three.description, """
            ·······
            ·······
            ·······
            ·······
            ···O···
            ···O···
            """)
        let four = two.shifted(.up, distance: 2).intersection(two)
        XCTAssertEqual(four.description, """
            ·······
            ·······
            ·······
            ·······
            ·······
            ···O···
            """)
    }

    func testFindAllFours() throws {
        for row in 0...2 {
            for col in 0...3 {
                func test(dh: Int, dv: Int, ov: Int = 0) {
                    var grid = Grid()
                    grid[Pos(row: row + 0 * dv + ov, col: col + 0 * dh)] = true
                    grid[Pos(row: row + 1 * dv + ov, col: col + 1 * dh)] = true
                    grid[Pos(row: row + 2 * dv + ov, col: col + 2 * dh)] = true
                    grid[Pos(row: row + 3 * dv + ov, col: col + 3 * dh)] = true
                    XCTAssertEqual(grid.findFours()?.data.nonzeroBitCount, 4)
                    XCTAssertTrue(grid.isWin)
                }
                test(dh: 1, dv:  0)
                test(dh: 0, dv:  1)
                test(dh: 1, dv:  1)
                test(dh: 1, dv: -1, ov: 3)
            }
        }
    }

    func testStartIterator() throws {
        XCTAssertEqual(Grid.full.startIndex, 0)
        XCTAssertEqual(Grid(0x12).startIndex, 1)
        XCTAssertEqual(Grid(0x14).startIndex, 2)
        XCTAssertEqual(Grid(0x100).startIndex, 8)
    }

    func testEndIterator() throws {
        XCTAssertEqual(Grid.full.endIndex, 64)
    }

    func testIteratorAdvancing() throws {
        let sut = Self.testGrid
        var iterator = sut.startIndex
        var result: [Int] = []
        while iterator != sut.endIndex {
            result.append(iterator)
            iterator = sut.index(after: iterator)
        }
        XCTAssertEqual(result, Self.testGridIndices)
    }

    func testGridSequence() throws {
        let sut = Self.testGrid.makeIterator()
        XCTAssertTrue(sut.elementsEqual(Self.testGridIndices.map { Pos(bit: $0) }))
    }

    func testGridIndices() throws {
        let sut = Self.testGrid.indices
        XCTAssertTrue(sut.elementsEqual(Self.testGridIndices))
    }
}
