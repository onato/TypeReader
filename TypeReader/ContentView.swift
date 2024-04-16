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
                            documentViewModel.fileName = url.deletingPathExtension().lastPathComponent
                            documentViewModel.documentPages = PDFTextExtractor().extractPagesFromPDF(url: url)
                        }
                    }
                } else {
                    TabView(selection: $documentViewModel.currentPage) {
                        ForEach(0 ..< documentViewModel.documentPages.count, id: \.self) { index in
                            ScrollView {
                                ScrollViewReader { scrollViewProxy in
                                    ZStack(alignment: .top) {
                                        Text(documentViewModel.documentPages[index])
                                        if documentViewModel.currentPage == index {
                                            Text(documentViewModel.textSpoken)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.bottom, 200)
                                                .hidden()
                                                .id(1)
                                            Text(documentViewModel.textSpoken).foregroundColor(.gray)
                                                + Text(documentViewModel.textBeingSpoken).foregroundColor(.red)
                                                + Text(documentViewModel.textToSpeak)
                                        }
                                    }
                                    .onChange(of: documentViewModel.textSpoken) {
                                        if abs(documentViewModel.dateLastTouched.timeIntervalSinceNow) > 5 {
                                            withAnimation {
                                                scrollViewProxy.scrollTo(1, anchor: .bottom)
                                            }
                                        }
                                    }
                                }
                                .padding()
                            }
                            .tag(index)
                            .simultaneousGesture(
                                DragGesture()
                                    .onChanged { _ in
                                        documentViewModel.didTouchScreen()
                                    }
                            )
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
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
                ToolbarItem(placement: .topBarLeading) {}
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
