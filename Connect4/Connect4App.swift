import SwiftUI
import Connect4Model


@main
struct Connect4App: App {
    var body: some Scene {
        WindowGroup {
            GameView()
        }
        .commands {
            GameCommands()
        }
    }
}


struct GameCommands: Commands {
    @FocusedObject private var game: ObservableGame?
    @FocusedBinding(\.pcbMode) private var pcbMode: Bool?

    var body: some Commands {
        CommandGroup(after: .newItem) {
            Section {
                Button("Start New Game", action: newGame)
                    .keyboardShortcut(KeyboardShortcut(KeyEquivalent("r"), modifiers: [.command]))
            }
        }

        CommandGroup(after: .sidebar) {
            Section {
                Button("PCB Mode", action: togglePCBMode)
                    .keyboardShortcut(KeyboardShortcut(KeyEquivalent("P"), modifiers: [.command]))
            }
        }
    }

    func newGame() {
        game?.reset()
    }

    func togglePCBMode() {
        pcbMode?.toggle()
    }
}


struct GameKey: FocusedValueKey {
    typealias Value = Binding<Game>
}

extension FocusedValues {
    var game: Binding<Game>? {
        get { self[GameKey.self] }
        set { self[GameKey.self] = newValue }
    }
}

struct PCBModeKey: FocusedValueKey {
    typealias Value = Binding<Bool>
}

extension FocusedValues {
    var pcbMode: Binding<Bool>? {
        get { self[PCBModeKey.self] }
        set { self[PCBModeKey.self] = newValue }
    }
}
