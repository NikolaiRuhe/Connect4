import SwiftUI
import Connect4Model


struct BoardView: View {
    var game: Game
    var makeTurn: (Pos) -> Void
    @State var hoverPos: Pos? = nil

    var body: some View {
        GameMatrixView { pos in
            ZStack {
                if let player = game.board[pos] {
                    Circle()
                        .fill(player.color)
                        .padding(4)
                        .id(pos)
                        .transition(.offset(y: CGFloat(5 - pos.row) * -58 - 29))

                    if case .win(_, let grid) = game.state, grid[pos] == false {
                        Rectangle()
                            .fill(Color.black).opacity(0.5)
                    }

                    Circle().fill(Self.shadowGradient)
                        .transition(.opacity)

                } else if let player = game.currentPlayer, pos == hoverPos {
                    Circle()
                        .fill(player.color)
                        .padding(4)
                        .offset(y: CGFloat(5 - pos.row) * -58 - 39)
                        .transition(.identity)
                }
            }
        }
        .overlay {
            GameMatrixView { _ in
                Cell().fill(Color.boardBlue, style: .init(eoFill: true))
            }
        }
        .animation(.easeIn, value: game)
        .onContinuousHover { phase in
            switch phase {
            case .active(let position):
                hoverPos = dropPos(at: position)
            case .ended:
                hoverPos = nil
            }
        }
        .onTapGesture {
            guard let hoverPos else { return }
            makeTurn(hoverPos)
            self.hoverPos = nil
//            if hoverPos.row + 1 != Pos.rowIndices.upperBound {
//                hoverPos.row += 1
//                self.hoverPos = hoverPos
//            }
        }
        .padding(4)
        .border(Color.boardBlue, width: 4)
        .padding(10)
        .padding([.top], 30)
    }

    func pos(at position: CGPoint) -> Pos? {
        let row = 5 - Int(round((position.y - 25) / 58))
        guard Pos.rowIndices.contains(row) else { return nil }
        let col = Int(round((position.x - 25) / 58))
        guard Pos.colIndices.contains(col) else { return nil }
        return Pos(row: row, col: col)
    }

    func dropPos(at position: CGPoint) -> Pos? {
        guard let pos = pos(at: position) else { return nil }
        return game.board.dropPos(atCol: pos.col)
    }

    static let shadowGradient = RadialGradient(
        colors: [
            Color(white: 0, opacity: 0),
            Color(white: 0, opacity: 0.15),
            Color(white: 0, opacity: 0.5)
        ],
        center: UnitPoint(x: 0.50, y: 0.51),
        startRadius: 20.00,
        endRadius: 25.00
    )
}

extension Player {
    var color: Color {
        switch self {
        case .odd: return .yellow
        case .even: return .red
        }
    }
}

extension Color {
    static let boardBlue = Color(red: 0.25, green: 0.55, blue: 1.0)
}

struct Cell: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path(rect)
        path.addEllipse(in: rect.insetBy(dx: 4, dy: 4))
        return path
    }

}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        return BoardView(
            game: Game(
                board: Board(
                    0x000000150a0003,
                    0x0000000a150000
                )
            ),
            makeTurn: { pos in print(pos) }
        )
    }
}


struct GameMatrixView<CellContent: View>: View {
    var spacing: CGFloat = 0
    var cellSize: CGFloat = 58
    var cellContent: (Pos) -> CellContent

    init(spacing: CGFloat = 0, cellSize: CGFloat = 58, @ViewBuilder cellContent: @escaping (Pos) -> CellContent) {
        self.spacing = spacing
        self.cellSize = cellSize
        self.cellContent = cellContent
    }

    var body: some View {
        SwiftUI.Grid(horizontalSpacing: spacing, verticalSpacing: spacing) {
            ForEach(Pos.rowIndices.reversed(), id:\.self) { rowIndex in
                GridRow {
                    ForEach(Pos.colIndices, id: \.self) { colIndex in
                        cellContent(Pos(row: rowIndex, col: colIndex))
                            .frame(width: cellSize, height: cellSize)
                    }
                }
            }
        }
    }
}
