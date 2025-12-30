//
//  AboutModalView.swift
//  Sweet o meter
//
//  Created by MacBook Pro on 26/11/24.
//

import SwiftUI

struct AboutModalView: View {
    @Binding var showAboutModal: Bool  // Binding to control modal visibility

    var body: some View {
        VStack(spacing: 20) {
            Text("About")
                .font(.title)
                .bold()
                .padding()

            Text("Sweetometer is a fun and easy way to measure your sugar levels. For more information, visit our website.")
                .multilineTextAlignment(.center)  // This ensures the text is centered
                .padding()

            Button(action: {
                showAboutModal = false  // Close the modal when clicked
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

struct AboutModalView_Previews: PreviewProvider {
    static var previews: some View {
        AboutModalView(showAboutModal: .constant(true))
    }
}
