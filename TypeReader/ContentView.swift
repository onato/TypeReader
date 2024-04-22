import PDFKit
import SwiftUI

struct ContentView: View {
    @State private var documentViewModel = DocumentViewModel()

    init(documentPages: [String] = []) {
        documentViewModel.documentPages = documentPages
    }

    var body: some View {
        NavigationView {
            VStack {
                if documentViewModel.documentPages.isEmpty {
                    Button {
                        documentViewModel.showDocumentPicker = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .imageScale(.large)
                        Text("Open PDF")
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .sheet(isPresented: $documentViewModel.showDocumentPicker) {
                        DocumentPicker { url in
                            documentViewModel.fileURL = url
                            documentViewModel.fileName = url.deletingPathExtension().lastPathComponent
                            documentViewModel.documentPages = PDFTextExtractor().extractPagesFromPDF(url: url)
                        }
                    }
                } else {
                    PDFViewer(
                        url: documentViewModel.fileURL,
                        spokenText: $documentViewModel.textSpoken,
                        highlightSentence: $documentViewModel.currentSentence,
                        highlightWord: $documentViewModel.textBeingSpoken,
                        currentPage: $documentViewModel.currentPage,
                        isTracking: $documentViewModel.isTracking
                    )
                    .edgesIgnoringSafeArea(.all)
                }
            }
            .padding()
            .navigationBarTitle(documentViewModel.subtitle, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        documentViewModel.showingSettings.toggle()
                    }) {
                        Image(systemName: "gear")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        documentViewModel.isTracking = true
                    }) {
                        Image(systemName: "scope")
                    }
                }
            }
        }
        .sheet(isPresented: $documentViewModel.showingSettings) {
            // Content of the sheet
            SpeechSettingsView()
        }
    }
}

#Preview {
    ContentView(documentPages: ["This is the first page of the PDF", "This is the second page of the PDF"])
}
