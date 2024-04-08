import Nimble
@testable import TypeReader
import XCTest

final class PDFTextExtractorTests: XCTestCase {
    func test_PDF_whenExtracting_shouldLoadPages() throws {
        let sut = PDFTextExtractor()

        let pdfURL = Bundle(for: type(of: self)).url(forResource: "Lockhart_2002_-_A_Mathematician's_Lament", withExtension: "pdf")!
        let pages = sut.extractPagesFromPDF(url: pdfURL)
        let page1 = pages[0]
        
        expect(pages.count) == 25
        expect(page1).to(beginWith("A Mathematician’s Lament\nby Paul Lockhart"))
        expect(page1.trimmingCharacters(in: .whitespacesAndNewlines))
            .to(endWith("She’s going to make one hell of a musician someday.”"))
    }
}
