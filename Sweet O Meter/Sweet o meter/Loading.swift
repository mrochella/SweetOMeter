//
//  Loading.swift
//  Sweet o meter
//
//  Created by MacBook Pro on 26/11/24.
//

//
//  ContentView.swift
//  loading page sweet o meter
//
//  Created by student on 19/11/24.
//

import SwiftUI

struct Loading: View {
    @State private var progress: CGFloat = 0.0
    var body: some View {
        VStack {
            Spacer()
            
            // Image
            Image("Logo") // Replace with your image name in Assets.xcassets
                .resizable()
                .scaledToFit()
                .frame(width: 500, height: 500) // Adjust the size as needed
            
            Spacer()
            
            // Tagline
            Text("Your sugar tracker.")
                .font(.system(size: 25, weight: .medium))
                .foregroundColor(.red)
                .padding(.bottom, 20)
            
            // Progress Bar
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 20)
                    .foregroundColor(Color.pink.opacity(0.3)) // Background of the bar
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: progress, height: 20) // Dynamic width based on progress
                    .foregroundColor(.pink) // Foreground color
                    .animation(.easeInOut(duration: 0.5), value: progress)
            }
            .padding(.horizontal, 40)
            
            // Dynamic percentage text
            Text("\(Int((progress / 300) * 100))%") // Adjust percentage calculation
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.red)
                .padding(.top, 5)
            
            Spacer()
        }
        .padding()
        .onAppear {
            // Start a timer to simulate progress
            Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
                if progress >= 300 { // Reset progress if it reaches 100%
                } else {
                    progress += 10 // Increment progress
                }
            }
        }
    }
}


#Preview {
    Loading()
}
