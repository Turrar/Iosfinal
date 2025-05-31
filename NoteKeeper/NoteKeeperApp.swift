import SwiftUI
import Firebase

@main
struct NoteKeeperApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            NotesListView() // мы его позже создадим
        }
    }
}
