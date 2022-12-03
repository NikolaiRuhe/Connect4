import Foundation

/// A game of Connect 4 consists of a board and additional player game state.
public struct Game: Equatable {
    public var state: State
    public var board: Board
    public var script: Script

    public init(state: Game.State = .turn(.odd), board: Board = Board()) {
        self.state = state
        self.board = board
        self.script = Script()
    }

    public init(replayFrom script: Script) {
        self.state = .turn(.odd)
        self.board = Board()
        self.script = script

        for turn in script {
            let pos = board.dropPos(atCol: turn.col)!
            board.with(turn.player) { grid in
                grid[pos] = true
            }
        }

        if let grid = board.oddPlayerGrid.findFours() {
            state = .win(.odd, grid)
        } else if let grid = board.evenPlayerGrid.findFours() {
            state = .win(.even, grid)
        } else {
            state = .turn(script.player)
        }
    }
}


extension Game {
    public enum State: Equatable {
        case turn(Player)
        case win(Player, Grid)
        case draw
    }

    public var currentPlayer: Player? {
        if case .turn(let player) = state {
            assert(script.player == player)
            return player
        } else { return nil }
    }

    public mutating func reset() {
        board = Board()
        state = .turn(.odd)
        script = Script()
    }

    @discardableResult
    public mutating func makeTurn(atCol col: Int) -> Bool {
        guard let player = currentPlayer else { return false }
        guard let pos = board.dropPos(atCol: col) else { return false }

        script.append(col: col)
        let win = board.with(player) { grid in
            grid[pos] = true
            return grid.findFours()
        }

        if let win {
            state = .win(player, win)
        } else {
            state = .turn(player.other())
        }

        return true
    }
}
