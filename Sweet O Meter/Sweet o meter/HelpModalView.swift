//
//  HelpModalView.swift
//  Sweet o meter
//
//  Created by MacBook Pro on 26/11/24.
//

import SwiftUI

struct HelpModalView: View {
    @Binding var showHelpModal: Bool  // Binding to control modal visibility

    var body: some View {
        VStack(spacing: 20) {
            Text("How can we help you?")
                .font(.title)
                .bold()
                .padding()

            Text("If you need assistance, please visit our help page at www.sweetometer.com/help or contact us via email.")
                .multilineTextAlignment(.center)
                .padding()

            Button(action: {
                showHelpModal = false  // Close the modal when clicked
            }) {
                Text("Close")
                    .frame(maxWidth: .infinity)  // Makes the button stretch horizontally
                    .padding()
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .cornerRadius(100)  // Sets the corner radius to 100, making it pill-shaped
            }
            .padding([.leading, .trailing], 20)  // Adds some horizontal padding for better spacing
        }
        .padding()  // Adds padding around the entire VStack
    }
}

struct HelpModalView_Previews: PreviewProvider {
    static var previews: some View {
        HelpModalView(showHelpModal: .constant(true))
    }
}
