//
//  Settings.swift
//  Sweet o meter
//
//  Created by MacBook Pro on 26/11/24.
//

import SwiftUI

struct Settings: View {
    
    // Use @AppStorage to store dark mode state persistently
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var isNotificationEnabled = false
    @State private var showHelpModal = false
    @State private var showAboutModal = false
    @State private var showNotificationAlert = false  // State for showing the alert

    var body: some View {
        GeometryReader { geometry in
            

            VStack {
                Text("Settings")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color(hex: "#ff66c4"))
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
                
                Divider()
                    .background(isDarkMode ? Color.white : Color.gray)
                // Settings Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("General")
                        .font(.title2)
                        .bold()
                        .foregroundColor(isDarkMode ? .white : .black)
                        .padding(.leading, 15)
                    
                    // Dark Mode Section with Icon
                    HStack {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.gray)
                            .padding(.leading, 15)
                        
                        Toggle("Dark Mode", isOn: $isDarkMode)
                            .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#ff66c4")))
                            .foregroundColor(isDarkMode ? .white : .black) // Change the toggle text color
                            .padding(.horizontal)
                            .padding(.leading, -15)
                    }
                    
                    // Notification Section with Icon
                    HStack {
                        Image(systemName: "bell.fill")  // Notification Icon
                            .foregroundColor(.gray)
                            .padding(.leading, 15)
                        
                        Toggle("Notification", isOn: $isNotificationEnabled)
                            .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#ff66c4")))
                            .foregroundColor(isDarkMode ? .white : .black) // Change the toggle text color
                            .padding(.horizontal)
                            .padding(.leading, -15)
                            .onChange(of: isNotificationEnabled) { newValue in
                                if newValue {
                                    showNotificationAlert = true
                                }
                            }
                    }
                    
                    // Help Section - Open Help Modal
                    Button(action: {
                        showHelpModal.toggle()
                    }) {
                        HStack {
                            Image(systemName: "headphones")
                                .foregroundColor(.gray)
                            Text("Help")
                                .foregroundColor(isDarkMode ? .white : .black)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .sheet(isPresented: $showHelpModal) {
                        HelpModalView(showHelpModal: $showHelpModal)
                    }
                    
                    // About Section - Open About Modal
                    Button(action: {
                        showAboutModal.toggle()
                    }) {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.gray)
                            Text("About")
                                .foregroundColor(isDarkMode ? .white : .black)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .sheet(isPresented: $showAboutModal) {
                        AboutModalView(showAboutModal: $showAboutModal)
                    }
                    
                    Divider()
                        .background(isDarkMode ? Color.white : Color.gray)
                    
                    // Contact Us Section
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("Contact Us")
                            .font(.title2)
                            .bold()
                            .foregroundColor(isDarkMode ? .white : .black)
                            .padding(.leading, 15)
                        
                        // Instagram link
                        Link(destination: URL(string: "https://www.instagram.com/sweetometer")!) {
                            HStack {
                                Image(systemName: "camera")
                                    .foregroundColor(.gray)
                                Text("@sweetometer")
                                    .foregroundColor(isDarkMode ? .white : .black)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        
                        // Email link
                        Link(destination: URL(string: "mailto:sweetometer@gmail.com")!) {
                            HStack {
                                Image(systemName: "envelope")
                                    .foregroundColor(.gray)
                                Text("sweetometer@gmail.com")
                                    .foregroundColor(isDarkMode ? .white : .black)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        
                        // Website link (sweet-o-meter)
                        Link(destination: URL(string: "https://www.sweet-o-meter.com")!) {
                            HStack {
                                Image(systemName: "link")
                                    .foregroundColor(.gray)
                                Text("sweet-o-meter")
                                    .foregroundColor(isDarkMode ? .white : .black) // Dynamic text color
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        
                        // Website link (sweetometer.com)
                        Link(destination: URL(string: "https://www.sweetometer.com")!) {
                            HStack {
                                Image(systemName: "globe")
                                    .foregroundColor(.gray)
                                Text("sweetometer.com")
                                    .foregroundColor(isDarkMode ? .white : .black)
                                Spacer()
                            }
                            .padding(.bottom, 15)
                            .padding(.horizontal)
                        }
                    }
                    .background(isDarkMode ? Color.black : Color.white)
                    .cornerRadius(12)
                    
                    Divider()
                        .background(isDarkMode ? Color.white : Color.gray)
                    
                }
                .background(isDarkMode ? Color.black : Color.white)
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .alert(isPresented: $showNotificationAlert) {
                    Alert(
                        title: Text("Notifications Enabled"),
                        message: Text("You have enabled notifications. You will now receive notifications."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .background(isDarkMode ? Color.black : Color.white)
    }
}

// Preview Provider for ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
            .preferredColorScheme(.light) // Preview in light mode
    }
}
