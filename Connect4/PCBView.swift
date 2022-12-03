import SwiftUI
import Connect4Model


struct PCBView: View {
    var game: Game
    var makeTurn: (Pos) -> Void
    @State var hoverPos: Pos? = nil

    var body: some View {
        SwiftUI.Grid(horizontalSpacing: 8, verticalSpacing: 8) {
            ForEach(Pos.rowIndices.reversed(), id:\.self) { rowIndex in
                GridRow {
                    ForEach(Pos.colIndices, id: \.self) { colIndex in
                        let pos = Pos(row: rowIndex, col: colIndex)
                        
                        ZStack {
                            if let player = game.board[pos] {
                                if case .win(_, let grid) = game.state, grid[pos] == false {
                                    Circle()
                                        .fill(player.gradient)
                                        .scaleEffect(1.8)
                                        .blendMode(.plusLighter)
                                } else {
                                    Circle()
                                        .fill(player.gradient)
                                        .scaleEffect(3)
                                        .blendMode(.plusLighter)
                                }
                            } else if let player = game.currentPlayer, pos == hoverPos {
                                Circle()
                                    .fill(player.gradient)
                                    .scaleEffect(2)
                                    .blendMode(.plusLighter)
                            }
                        }
                        .frame(width: 50.0, height: 50.0)
                    }
                }
            }
        }
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
            self.hoverPos = game.board.dropPos(atCol: hoverPos.col)
        }
        .padding(18)
        .background {
            Image("PCB").resizable()
                .overlay(RoundedRectangle(cornerRadius: 15).fill(Color(white: 0, opacity: 0.5)))
        }
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
}

extension Player {
    var gradient: RadialGradient {
        switch self {
        case .odd:  return .playerAGradient
        case .even: return .playerBGradient
        }
    }
}

extension RadialGradient {
    static let playerAGradient = RadialGradient(
        colors: [
            Color(red: 0.4, green: 1, blue: 0.2),
            Color(red: 0.3, green: 0.3, blue: 0),
            Color(red: 0.1, green: 0.1, blue: 0),
            Color(red: 0.1, green: 0.1, blue: 0),
            Color(red: 0.1, green: 0.1, blue: 0),
            Color(red: 0.05, green: 0.05, blue: 0),
            Color(red: 0.02, green: 0.02, blue: 0),
            Color(red: 0, green: 0, blue: 0),
        ],
        center: UnitPoint(x: 0.50, y: 0.50),
        startRadius: 5,
        endRadius: 25
    )

    static let playerBGradient = RadialGradient(
        colors: [
            Color(red: 1, green: 0.5, blue: 0.5),
            Color(red: 0.5, green: 0, blue: 0),
            Color(red: 0.4, green: 0, blue: 0),
            Color(red: 0.3, green: 0, blue: 0),
            Color(red: 0.15, green: 0, blue: 0),
            Color(red: 0.05, green: 0, blue: 0),
            Color(red: 0.02, green: 0, blue: 0),
            Color(red: 0, green: 0, blue: 0),
        ],
        center: UnitPoint(x: 0.50, y: 0.50),
        startRadius: 5,
        endRadius: 25
    )
}
struct PCBView_Previews: PreviewProvider {
    static var previews: some View {
        return PCBView(
            game: Game(
                board: Board(
                    0x000000150a0001,
                    0x0100000a150000
                )
            ),
            makeTurn: { pos in print(pos) }
        )
    }
}
