import SwiftUI

import Foundation

// Function to extract the first number (float or integer) from inputText
func extractFirstNumber(from text: String) -> Double? {
    // Regular expression to match the first number (integer or float)
    let regex = try? NSRegularExpression(pattern: "([-+]?[0-9]*\\.?[0-9]+)", options: [])
    let range = NSRange(location: 0, length: text.utf16.count)
    
    if let match = regex?.firstMatch(in: text, options: [], range: range) {
        if let range = Range(match.range(at: 0), in: text) {
            // Extract and return the number as a Double
            let numberString = String(text[range])
            return Double(numberString)
        }
    }
    
    return nil // Return nil if no number is found
}

struct InputPage: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false  // Added Dark Mode Persistence
    @State private var productName: String = ""
    @State private var sugarWeight: String = ""
    @State private var sugarWeightchoose: Double = 0.0
    let sugarRange: ClosedRange<Double> = 0.0...100.0
    let sugarStep: Double = 1.0
    @State private var isSliderActive: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @EnvironmentObject var productData: ProductData
    @Binding var inputText: String
    

    var body: some View {
        
        VStack {
            // Header
            ZStack {
                Image("Logo Header")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 100)
                    .padding(.top, 40)
            }
            
            Form {
                // Input Fields
                VStack {
                    Text("Add Entry")
                        .font(.largeTitle)
                        .foregroundColor(Color(hex: "#ff66c4"))
                        .fontWeight(.bold)
                        .padding(.bottom, 30)
                        .padding(.top, 30)
                    
                    Spacer()
                    
                    // Product Name Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Add Product Name")
                            .font(.headline)
                        TextField("Enter your product name", text: $productName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 20)
                    }
                    
                    Spacer()
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Extracted Text from Scan")
                            .font(.headline)
                        Text(inputText)
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.bottom, 20)
                    }
                    
                    
                    // Sugar Weight Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Add Sugar Weight")
                            .font(.headline)
                        
                        Toggle("Use Slider", isOn: $isSliderActive)
                            .padding()
                            .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#ff66c4")))
                        
                        if isSliderActive {
                            Slider(value: $sugarWeightchoose, in: sugarRange, step: sugarStep)
                                .padding()
                            Text("Selected sugar weight: \(String(format: "%.1f", sugarWeightchoose)) g")
                                .padding()
                        } else {
                            if !inputText.isEmpty {
                                Text(inputText)
                                    .font(.body)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 20)
                            }
                            else {
                                TextField("Enter your sugar weight", text: $sugarWeight)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.decimalPad)
                                    .onChange(of: sugarWeight) { newValue in
                                        if let value = Double(newValue) {
                                            sugarWeightchoose = value
                                        }
                                    }
                            }

                        }
                    }
                    
                    Spacer()
                    
                    // Add Button
                    Button(action: {
                        if productName.isEmpty {
                            alertMessage = "Please input the product"
                            showAlert = true
                        } else {
                            let sugarValue: Double

                            if isSliderActive {
                                sugarValue = sugarWeightchoose
                            } else {
                                // First, try to get a value from inputText (remove any spaces, take number part)
                                if let extractedValue = extractFirstNumber(from: inputText) {
                                    sugarValue = extractedValue
                                } else {
                                    // If inputText is not a valid number, fall back to sugarWeight
                                    sugarValue = Double(sugarWeight) ?? 0.0
                                }
                            }
                            let newProduct = Product(name: productName, sugarWeight: sugarValue)
                            
                            productData.products.append(newProduct)
                            
                            alertMessage = "Yay, \(productName) succesfully added"
                            showAlert = true
                            
                            // Reset fields
                            productName = ""
                            sugarWeight = ""
                            sugarWeightchoose = 0.0
                            isSliderActive = false
                            
                        }
                    }) {
                        Text("Input")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "FF66C4"))
                            .foregroundStyle(.white)
                            .cornerRadius(100)
                    }
                    .padding(.vertical, 20)
                    
                    Spacer()
                }
                
                // Product List
               
            }
            .padding()
//            .background(Color(.systemGray6))
            .navigationTitle("Sweet O'Meter")
            .navigationBarTitleDisplayMode(.inline)
        }
        .edgesIgnoringSafeArea(.top)
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    let mockData = ProductData() // Create an empty ProductData instance

    return InputPage(inputText: .constant("")) // Provide the empty ProductData instance and the binding for inputText
        .environmentObject(mockData) // Provide the empty ProductData instance
}
