import PDFKit
import SwiftUI

public struct PDFViewer: UIViewRepresentable {
    var url: URL

    @Binding var spokenText: String
    @Binding var highlightSentence: String
    @Binding var highlightWord: String
    @Binding var currentPage: Int
    @Binding var isTracking: Bool

    public func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true

        return pdfView
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    public func updateUIView(_ uiView: PDFView, context _: Context) {
        if let document = uiView.document {
            let highlighter = PDFHighlighter(document: document, currentPageNumber: currentPage, spokenText: spokenText, highlightWord: highlightWord)
            highlighter.clearHighlights()
            highlighter.highlightTextInDocument(sentence: highlightSentence, word: highlightWord)
            
            if isTracking, let page = document.page(at: currentPage) {
                let destination = PDFDestination(page: page, at: CGPoint(x: 0, y: page.bounds(for: .mediaBox).height))
                uiView.go(to: destination) // Scroll to the specific point on the page
            }
        }
    }
}
