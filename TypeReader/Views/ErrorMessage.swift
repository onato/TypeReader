import SwiftUI

struct ErrorMessage: View {
    var errorDescription: String // Description of the error

    var body: some View {
        VStack {
            Image(systemName: "x.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.red)
                .frame(width: 50, height: 50)

            Text(errorDescription)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            .padding(.top, 4)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(5)
        .shadow(radius: 2)
    }
}



struct ErrorMessage_Previews: PreviewProvider {
    static var previews: ErrorMessage {
        ErrorMessage(
            errorDescription: "An unexpected error occurred. Please try again."
        )
    }
}
