//
//  ContentView.swift
//  TypeReader
//
//  Created by Stephen Williams on 08/04/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var documentPages: [String] = []
    @State private var showDocumentPicker = false
    @State private var showingSettings = false

    var body: some View {
        NavigationView {
            VStack {
                if documentPages.isEmpty {
                    Button("Select PDF") {
                        showDocumentPicker = true
                    }
                    .sheet(isPresented: $showDocumentPicker) {
                        DocumentPicker { url in
                            documentPages = PDFTextExtractor().extractPagesFromPDF(url: url)
                            SpeechSynthesizer.shared.speakText(documentPages[1])
                        }
                    }
                } else {
                    TabView {
                        ForEach(0 ..< documentPages.count, id: \.self) { index in
                            Text(documentPages[index])
                                .padding()
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                }
            }
            .padding()
            .navigationBarTitle("Home", displayMode: .inline)
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
    }
}

#Preview {
    ContentView()
}
