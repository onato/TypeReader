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
                    Button("Select PDF") {
                        documentViewModel.showDocumentPicker = true
                    }
                    .sheet(isPresented: $documentViewModel.showDocumentPicker) {
                        DocumentPicker { url in
                            documentViewModel.documentPages = PDFTextExtractor().extractPagesFromPDF(url: url)
                        }
                    }
                } else {
                    TabView(selection: $documentViewModel.currentPage) {
                        ForEach(0 ..< documentViewModel.documentPages.count, id: \.self) { index in
                            ScrollView {
                                ZStack {
                                    Text(documentViewModel.documentPages[index])
                                    if documentViewModel.currentPage == index {
                                        Text(documentViewModel.textSpoken).foregroundColor(.gray)
                                            + Text(documentViewModel.textBeingSpoken).foregroundColor(.red)
                                            + Text(documentViewModel.textToSpeak)
                                            
                                    }
                                }
                                .padding()
                            }.tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                }
            }
            .padding()
            .navigationBarTitle(documentViewModel.documentPages.isEmpty ? "" : "\(documentViewModel.currentPage + 1)/\(documentViewModel.documentPages.count)", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        documentViewModel.showingSettings.toggle()
                    }) {
                        Image(systemName: "gear")
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
