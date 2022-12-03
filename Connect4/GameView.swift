import SwiftUI
import Connect4Model


struct GameView: View {
    @Environment(\.undoManager) var undoManager
    @StateObject var viewModel = ObservableGame()
    @State var pcbMode = false

    var body: some View {

        // The following line stores the undoManager in the observable model.
        // This solution smells like a bad workaround. I'm not aware of another
        // way to use the proper undoManager in cases where commands from the
        // menu trigger changes in the model. To be researched...
        let _ = viewModel.undoManager = undoManager

        VStack {
            if pcbMode {
                PCBView(game: viewModel.game) { pos in
                    viewModel.makeTurn(atCol: pos.col)
                }
            } else {
                BoardView(game: viewModel.game) { pos in
                    viewModel.makeTurn(atCol: pos.col)
                }
            }

            Spacer()

            Text("Turns: \(viewModel.game.script.count)")
                .font(.caption)
            Text("Board(\(viewModel.game.board.oddPlayerGrid.shortDescription), \(viewModel.game.board.evenPlayerGrid.shortDescription))")
                .textSelection(.enabled)
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .focusedSceneObject(viewModel)
        .focusedSceneValue(\.pcbMode, $pcbMode)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
