import SwiftUI
import Connect4Model


class ObservableGame: ObservableObject {
    @Published var game = Game()
    var undoManager: UndoManager? = nil

    @discardableResult
    func makeTurn(atCol col: Int) -> Bool {
        undoManager?.registerUndo(withTarget: self) { [previousState = game] observableGame in
            observableGame.resetGameState(to: previousState)
        }
        return game.makeTurn(atCol: col)
    }

    func reset() {
        undoManager?.registerUndo(withTarget: self) { [previousState = game] observableGame in
            observableGame.resetGameState(to: previousState)
        }
        return game.reset()
    }

    func resetGameState(to newState: Game) {
        undoManager?.registerUndo(withTarget: self) { [previousState = game] observableGame in
            observableGame.resetGameState(to: previousState)
        }
        game = newState
    }
}
