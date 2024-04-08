//
//  ContentView.swift
//  TypeReader
//
//  Created by Stephen Williams on 08/04/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var documentUrl: URL?

    var body: some View {
        VStack {
            Text("Selected File: \(documentUrl?.lastPathComponent ?? "None")")

            Button("Import Text File") {
                showDocumentPicker()
            }
        }
        .padding()
    }
    
    private func showDocumentPicker() {
            let picker = DocumentPicker { url in
                self.documentUrl = url
                // Process the selected file URL here
            }
            // Present the document picker
            if let window = UIApplication.shared.windows.first, let rootVC = window.rootViewController {
                let vc = UIHostingController(rootView: picker)
                vc.modalPresentationStyle = .formSheet
                rootVC.present(vc, animated: true)
            }
        }
}

#Preview {
    ContentView()
}
