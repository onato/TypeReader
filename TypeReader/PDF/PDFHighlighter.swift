import Foundation
import PDFKit

struct PDFHighlighter {
    let document: PDFDocument
    let currentPageNumber: Int
    let spokenText: String
    let highlightWord: String

    func clearHighlights() {
        for pageIndex in 0 ..< document.pageCount {
            if let page = document.page(at: pageIndex) {
                let highlight = PDFAnnotationSubtype.highlight.rawValue
                let annotations = page.annotations.filter { $0.type == String(highlight.dropFirst()) }
                for annotation in annotations {
                    page.removeAnnotation(annotation)
                }
            }
        }
    }

    @discardableResult
    func highlightTextInDocument(sentence: String, word: String) -> Bool {
        guard !sentence.isEmpty, let currentPage = document.page(at: currentPageNumber) else {
            return false
        }

        
        var didHighlight = false
        let spokenSelection = document.findString(spokenText, withOptions: []).first
        if let nextWordSelection = document.findString(word, fromSelection: spokenSelection, withOptions: []) {
            let selections = document.findString(sentence, withOptions: .caseInsensitive)
            for selection in selections {
                let pages = selection.pages
                for page in pages where page == currentPage {
                    highlight(selection: selection, wordSelection: nextWordSelection, withColor: .systemBlue.withAlphaComponent(0.2), in: currentPage)
                    didHighlight = true
                }
            }
        }
        return didHighlight
    }

    func highlight(selection: PDFSelection, wordSelection: PDFSelection?, withColor color: UIColor, in page: PDFPage) {
        let annotations = selection.selectionsByLine().map { lineSelection -> PDFAnnotation in
            let bounds = lineSelection.bounds(for: page)
            return PDFAnnotation(bounds: bounds, forType: .highlight, withProperties: nil)
        }
        for annotation in annotations {
            annotation.color = color
            page.addAnnotation(annotation)
            if let wordSelection {
                highlightWordWithinBounds(highlightWord, wordSelection: wordSelection, in: page, within: annotation.bounds)
            }
        }
    }

    func highlightWordWithinBounds(_: String, wordSelection: PDFSelection, in page: PDFPage, within sentenceBounds: CGRect) {
        let wordBounds = wordSelection.bounds(for: page)
        if sentenceBounds.contains(wordBounds) {
            highlight(selection: wordSelection, wordSelection: nil, withColor: .systemBlue.withAlphaComponent(0.5), in: page)
        }
    }
}
