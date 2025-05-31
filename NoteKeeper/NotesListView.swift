import SwiftUI

struct NotesListView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var showAddNote = false

    var body: some View {
        NavigationStack {
            VStack {
                // 🔹 Цитата дня
                if let quote = viewModel.quote {
                    Text(quote)
                        .font(.subheadline)
                        .padding()
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                // 🔹 Список заметок
                List {
                    if viewModel.notes.isEmpty {
                        Text("Пока нет заметок.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.notes) { note in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(note.title)
                                    .font(.headline)
                                Text(note.content)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(note.createdAt.formatted())
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                viewModel.deleteNote(viewModel.notes[index])
                            }
                        }
                    }
                }
            }
            .navigationTitle("Мои заметки")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddNote = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddNote) {
                AddNoteView(viewModel: viewModel)
            }
        }
    }
}
