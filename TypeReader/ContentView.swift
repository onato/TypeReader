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
    @State private var selectedTab = 1

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
                            SpeechSynthesizer.shared.speakText(documentPages[2])
                        }
                    }
                } else {
                    TabView(selection: $selectedTab) {
                        ForEach(0 ..< documentPages.count, id: \.self) { index in
                            ScrollView {
                                Text(documentPages[index])
                                    .padding()
                            }.tag(index)
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
        .onChange(of: selectedTab) { oldValue, newValue in
            SpeechSynthesizer.shared.speakText(documentPages[selectedTab])
        }
    }
}

#Preview {
    ContentView()
}
