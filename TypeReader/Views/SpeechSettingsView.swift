import AVFoundation
import SwiftUI

struct SpeechSettingsView: View {
    @ObservedObject var viewModel = SpeechSettingsViewModel()
    @State private var isSliding: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Picker("Voice", selection: $viewModel.selectedVoiceIdentifier) {
                    Section {
                        ForEach(viewModel.topVoices, id: \.identifier) { voice in
                            Text(voice.name + " (\(voice.language))").tag(voice.identifier)
                        }
                    } header: {
                        Text("Enhanced Voices")
                    }
                    ForEach(viewModel.voices) { languageGroup in
                        Section {
                            ForEach(languageGroup.regions, id: \.identifier) { region in
                                Text(region.name).tag(region.identifier)
                            }
                        } header: {
                            Text(languageGroup.name)
                        }
                    }
                    
                }

                Slider(value: $viewModel.speechRate, in: AVSpeechUtteranceMinimumSpeechRate ... AVSpeechUtteranceMaximumSpeechRate, step: 0.01) {
                    Text("Rate")
                } minimumValueLabel: {
                    Text("Slow")
                } maximumValueLabel: {
                    Text("Fast")
                } onEditingChanged: { _ in
                    viewModel.releasedSlider()
                }
            }
            .navigationBarTitle("Speech Settings")
        }
    }
}
