import Foundation
import FirebaseFirestore

@MainActor
class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var quote: String? = nil

    private let db = Firestore.firestore()

    init() {
        Task {
            await loadNotes()
            loadQuote()
        }
    }

    // 🔄 Асинхронды жүктеу
    func loadNotes() async {
        do {
            let snapshot = try await db.collection("notes")
                .order(by: "createdAt", descending: true)
                .getDocuments()

            let documents = snapshot.documents
            let notes = documents.compactMap { Note.fromSnapshot($0) }

            self.notes = notes
        } catch {
            print("🔥 loadNotes error: \(error.localizedDescription)")
        }
    }

    // ➕ Жазба қосу
    func addNote(title: String, content: String) async {
        let note = Note(title: title, content: content)
        do {
            try await db.collection("notes").document(note.id).setData(note.toDict())
            await loadNotes()
        } catch {
            print("🔥 addNote error: \(error.localizedDescription)")
        }
    }

    // ❌ Жазбаны жою
    func deleteNote(_ note: Note) {
        db.collection("notes").document(note.id).delete { error in
            if error == nil {
                Task {
                    await self.loadNotes()
                }
            }
        }
    }

    // 🌐 Цитата
    func loadQuote() {
        Task {
            do {
                let fetched = try await QuoteService.fetchQuote()
                self.quote = fetched
            } catch {
                print("Quote loading error: \(error.localizedDescription)")
            }
        }
    }
}
