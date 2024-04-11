import SwiftUI

struct ContentView: View {
    @State private var documentViewModel = DocumentViewModel()
    @State private var showDocumentPicker = false
    @State private var showingSettings = false
    
    init(documentPages: [String] = [], showDocumentPicker: Bool = false, showingSettings: Bool = false, selectedTab: Int = 1) {
        self.showDocumentPicker = showDocumentPicker
        self.showingSettings = showingSettings
    }

    var body: some View {
        NavigationView {
            VStack {
                if documentViewModel.documentPages.isEmpty {
                    Button("Select PDF") {
                        showDocumentPicker = true
                    }
                    .sheet(isPresented: $showDocumentPicker) {
                        DocumentPicker { url in
                            documentViewModel.documentPages = PDFTextExtractor().extractPagesFromPDF(url: url)
                            SpeechSynthesizer.shared.speakText(documentViewModel.documentPages[documentViewModel.currentPage])
                        }
                    }
                } else {
                    TabView(selection: $documentViewModel.currentPage) {
                        ForEach(0 ..< documentViewModel.documentPages.count, id: \.self) { index in
                            ScrollView {
                                Text(documentViewModel.documentPages[index])
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
                        showingSettings.toggle()
                    }) {
                        Image(systemName: "gear")
                    }
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            // Content of the sheet
            SpeechSettingsView()
        }
        .onChange(of: documentViewModel.currentPage) { oldValue, newValue in
            SpeechSynthesizer.shared.speakText(documentViewModel.documentPages[documentViewModel.currentPage])
        }
    }
}

#Preview {
    ContentView(documentPages: ["This is the first page of the PDF", "This is the second page of the PDF"])
}
