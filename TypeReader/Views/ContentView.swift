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
                    VStack {
                        if !documentViewModel.errorMessage.isEmpty {
                            ErrorMessage(errorDescription: documentViewModel.errorMessage)
                        }
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
                            }
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        documentViewModel.isTracking = true
                    }) {
                        Image(systemName: "scope")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack(spacing: 50) {
                        Button(action: {
                            
                            documentViewModel.skipBack()
                        }) {
                            Image(systemName: "backward")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        }
                        .disabled(!documentViewModel.isPlaying)
                        .buttonStyle(PlainButtonStyle())
                        Button(action: {
                            documentViewModel.isPlaying.toggle()
                        }) {
                            Image(systemName: documentViewModel.isPlaying ? "pause.fill" : "play.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        }
                        .disabled(documentViewModel.documentPages.isEmpty)
                        .buttonStyle(PlainButtonStyle())
                        Button(action: {
                            documentViewModel.skipForward()
                        }) {
                            Image(systemName: "forward")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        }
                        .disabled(!documentViewModel.isPlaying)
                        .buttonStyle(PlainButtonStyle())
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
