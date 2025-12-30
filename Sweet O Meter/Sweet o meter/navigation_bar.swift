import SwiftUI

struct NavigationBar: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var selectedTab: Int = 0 // Track the selected tab
    @State private var showChoiceActionSheet: Bool = false // State to show the action sheet
    @State private var isScanSelected: Bool = false // Track whether scan is selected
    @EnvironmentObject var productData: ProductData
    
    @State private var showCameraView: Bool = false
    @State private var capturedImage: UIImage? = nil
    @State private var extractedText: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            // Main content changes based on selectedTab
            Group {
                switch selectedTab {
                case 0:
                    ContentView() // Your home content
                case 1:
                    InputPage(inputText: $extractedText) // Your input content
                default:
                    Settings() // Your menu content
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    selectedTab = 0 // Switch to Home tab
                }) {
                    Image(systemName: "house.fill")
                        .font(.title)
                        .foregroundColor(selectedTab == 0 ? Color(hex: "#ff66c4") : .gray)
                }
                .frame(maxWidth: .infinity)
                
                Button(action: {
                    selectedTab = 2 // Switch to Menu tab
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.title)
                        .foregroundColor(selectedTab == 2 ? Color(hex: "#ff66c4") : .gray)
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(isDarkMode ? Color.black : Color.white)
            .cornerRadius(16)
            .frame(height: 80)
            .shadow(color: Color.gray.opacity(0.3), radius: 5)
            .padding(.horizontal)
            
            .overlay(
                // Floating Add Button
                Button(action: {
                    showChoiceActionSheet = true // Show the action sheet when the "+" button is clicked
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#ff66c4"))
                            .frame(width: 64, height: 64)
                            .shadow(color: .gray.opacity(0.3), radius: 6)
                        
                        Image(systemName: "plus")
                            .font(.title)
                                .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 35) // Halfway touching the navbar
                .padding(.leading, (UIScreen.main.bounds.width - 400) / 2) // Center horizontally
                , alignment: .bottom
            )
        }
        .padding(.bottom, 20)
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.bottom)
        .actionSheet(isPresented: $showChoiceActionSheet) {
                    ActionSheet(
                        title: Text("Choose Input Method"),
                        message: Text("Would you like to input manually or scan?"),
                        buttons: [
                            .default(Text("Manual Input")) {
                                selectedTab = 1
                            },
                            .default(Text("Scan")) {
                                showCameraView = true // Show the camera
                            },
                            .cancel()
                        ]
                    )
                }
        .fullScreenCover(isPresented: $showCameraView) {
                    CameraView(capturedImage: $capturedImage, extractedText: $extractedText)
                        .onDisappear {
                            // After the camera view disappears, navigate to the input page if an image is captured
                            if capturedImage != nil {
                                selectedTab = 1 // Switch to InputPage tab
                            }
                        }
                }
    }
}

#Preview {
    let mockData = ProductData()
    return NavigationBar()
        .environmentObject(mockData)
}
