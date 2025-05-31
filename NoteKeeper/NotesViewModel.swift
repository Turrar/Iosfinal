import Foundation
import FirebaseFirestore

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var quote: String? = nil

    private let db = Firestore.firestore()

    init() {
        loadNotes()
        loadQuote()
    }

    // 🔄 Загрузка заметок из Firestore
    func loadNotes() {
        db.collection("notes")
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                self.notes = documents.compactMap { Note.fromSnapshot($0) }
            }
    }

    // ➕ Добавление заметки
    func addNote(title: String, content: String) {
        let note = Note(title: title, content: content)
        db.collection("notes").document(note.id).setData(note.toDict()) { error in
            if error == nil {
                self.loadNotes()
            }
        }
    }

    // ❌ Удаление заметки
    func deleteNote(_ note: Note) {
        db.collection("notes").document(note.id).delete { error in
            if error == nil {
                self.loadNotes()
            }
        }
    }

    // 🌐 Загрузка цитаты из внешнего API
    func loadQuote() {
        Task {
            do {
                let fetched = try await QuoteService.fetchQuote()
                await MainActor.run {
                    self.quote = fetched
                }
            } catch {
                print("Quote loading error: \(error.localizedDescription)")
            }
        }
    }
}
