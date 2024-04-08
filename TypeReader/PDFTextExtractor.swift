import Foundation
import PDFKit

struct PDFTextExtractor {
    func extractPagesFromPDF(url: URL) -> [String] {
        guard let document = PDFDocument(url: url) else {
            return []
        }
        var texts = [String]()

        for index in 0 ..< document.pageCount {
            guard let page = document.page(at: index) else {
                continue
            }
            if let text = page.string {
                texts.append(text)
            }
        }

        return texts
    }
}
