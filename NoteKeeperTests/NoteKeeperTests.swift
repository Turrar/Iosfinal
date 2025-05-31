import XCTest
@testable import NoteKeeper

final class NoteKeeperTests: XCTestCase {
    
    func testNoteModel() {
        let note = Note(title: "Тест тақырып", content: "Мазмұны", createdAt: Date())
        XCTAssertEqual(note.title, "Тест тақырып")
        XCTAssertEqual(note.content, "Мазмұны")
        XCTAssertFalse(note.id.isEmpty)
    }

    func testNoteToDict() {
        let note = Note(title: "Тақырып", content: "Контент")
        let dict = note.toDict()
        XCTAssertEqual(dict["title"] as? String, "Тақырып")
        XCTAssertEqual(dict["content"] as? String, "Контент")
        XCTAssertNotNil(dict["createdAt"])
    }

    func testViewModelAddNote() {
        let viewModel = NotesViewModel()
        let initialCount = viewModel.notes.count
        viewModel.addNote(title: "Test", content: "Some content")
        XCTAssertGreaterThanOrEqual(viewModel.notes.count, initialCount)
    }
}
 
