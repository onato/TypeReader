import Nimble
import PDFKit
import SwiftUI
@testable import TypeReader
import XCTest

final class PDFHighlighterTests: XCTestCase {
    let testSentence = "first thing to understand is that mathematics is an art."
    let testWord = "mathematics"

    func test_PDFViewer_whenClearingAnnotation_shouldRemoveAll() throws {
        let sut = sut()
        let annotation = PDFAnnotation(bounds: CGRect.zero, forType: .highlight, withProperties: nil)
        let page = try XCTUnwrap(sut.document.page(at: 1))
        page.addAnnotation(annotation)
        expect(page.annotations.count) == 1

        sut.clearHighlights()

        expect(page.annotations.count) == 0
    }

    func test_PDFViewer_whenHighlightingSentance_shouldAlsoHighlightWord() throws {
        let sut = sut()

        sut.highlightTextInDocument(
            sentence: testSentence,
            word: testWord
        )

        let page = try XCTUnwrap(sut.document.page(at: 2))
        expect(page.annotations.count) == 2
    }

    func test_PDFViewer_whenHighlightingNothing_shouldReturnFalse() {
        let sut = sut()

        let result = sut.highlightTextInDocument(
            sentence: "",
            word: ""
        )

        expect(result) == false
    }

    func test_PDFViewer_whenCantGetCurrentPage_shouldReturnFalse() {
        let sut = sut(currentPage: Int.max)

        let result = sut.highlightTextInDocument(
            sentence: testSentence,
            word: testWord
        )

        expect(result) == false
    }

    func test_PDFViewer_whenOnOtherPage_shouldReturnFalse() {
        let sut = sut(currentPage: 10)

        let result = sut.highlightTextInDocument(
            sentence: testSentence,
            word: testWord
        )

        expect(result) == false
    }
}

extension PDFHighlighterTests {
    func sut(currentPage: Int = 2) -> PDFHighlighter {
        let url = Bundle(for: type(of: self)).url(forResource: "Lockhart_2002_-_A_Mathematician's_Lament", withExtension: "pdf")!
        return PDFHighlighter(
            document: PDFDocument(url: url)!,
            currentPageNumber: currentPage,
            spokenText: "",
            highlightWord: ""
        )
    }
}
