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

    var body: some View {
        VStack {
            if documentPages.isEmpty {
                Button("Select PDF") {
                    showDocumentPicker = true
                }
                .sheet(isPresented: $showDocumentPicker) {
                    DocumentPicker { url in
                        documentPages = PDFTextExtractor().extractPagesFromPDF(url: url)
                        SpeechSynthesizer.shared.speakText(documentPages[0])
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
    }
}

#Preview {
    ContentView()
}
