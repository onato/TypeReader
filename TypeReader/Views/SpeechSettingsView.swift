import AVFoundation
import SwiftUI

struct SpeechSettingsView: View {
    @ObservedObject var viewModel = SpeechSettingsViewModel()

    var body: some View {
        NavigationView {
            Form {
                Picker("Voice", selection: $viewModel.selectedVoiceIdentifier) {
                    ForEach(viewModel.voices, id: \.identifier) { voice in
                        Text(voice.name + " (\(voice.language))").tag(voice.identifier)
                    }
                }

                Slider(value: $viewModel.speechRate, in: AVSpeechUtteranceMinimumSpeechRate ... AVSpeechUtteranceMaximumSpeechRate, step: 0.01) {
                    Text("Rate")
                } minimumValueLabel: {
                    Text("Slow")
                } maximumValueLabel: {
                    Text("Fast")
                }
            }
            .navigationBarTitle("Speech Settings")
        }
    }
}
