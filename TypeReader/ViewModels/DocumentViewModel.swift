import Foundation

@Observable
class DocumentViewModel {
    var documentPages: [String] = []
    var currentPage = 0
    var showingSettings = false
    var showDocumentPicker = false

    init() {}
}
