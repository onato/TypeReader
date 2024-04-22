import PDFKit
import SwiftUI

public struct PDFViewer: UIViewRepresentable {
    var url: URL

    @Binding var spokenText: String
    @Binding var highlightSentence: String
    @Binding var highlightWord: String
    @Binding var currentPage: Int

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
        }
    }
}
