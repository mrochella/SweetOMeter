import SwiftUI
import Foundation

struct Tip {
    let imageName: String
    let title: String
    let preview: String
}

struct ContentView: View {
    
    @EnvironmentObject var productData: ProductData
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false  // Added Dark Mode Persistence
    
    var totalSugarIntake: Double {
        productData.products.reduce(0) { total, product in
            total + product.sugarWeight
        }
    }
    
    var intTotalSugarIntake: Int {
        return Int(totalSugarIntake)
    }
    
    var remainingSugar: Double {
        sugarGoal - totalSugarIntake
    }
    
    var formattedSugarIntake: String {
        String(format: "%.2f", totalSugarIntake)
    }
    
    var formattedSugar: String {
        String(format: "%.2f", remainingSugar)
    }
    
    struct sugarIntakeData {
        let day: String
        let min : Int
        let intake : Int
        let limit : Int
    }
    
    
    @State private var sugarGoal: Double = 50.0
    var intSugarGoal: Int {
        return Int(sugarGoal)
    }
    
    @State private var tips: [Tip] = [
        Tip(imageName: "tip1", title: "Drink Water", preview: "Instead of sugary drinks, try drinking more water to stay hydrated and reduce sugar intake."),
        Tip(imageName: "tip2", title: "Use Natural Sweeteners", preview: "Natural sweeteners like honey or stevia can be good alternatives to refined sugar."),
        Tip(imageName: "tip3", title: "Fruit Desserts", preview: "For a healthier dessert, swap out sugary cakes for fruits like berries or apples."),
        Tip(imageName: "tip4", title: "Check Labels", preview: "Always check the sugar content on food labels to avoid hidden sugars."),
        Tip(imageName: "tip5", title: "Eat Fiber", preview: "Foods high in fiber can help you manage your sugar cravings throughout the day.")
    ]
    
    @State private var todayEntries: [String] = []
    @State private var selectedFood: String = "Apple"
    
    // Weekly data for graph
    @State private var weeklyIntake: [Int] = [15, 20, 25, 10, 110, 45, 30]
    let maxHeight: CGFloat = 100 // Set the max height for the bar

    let dayLabels2 = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    func formattedTodayDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE" // Short form of the day (e.g., "Mon", "Tue", "Wed")
        let today = Date()
        return dateFormatter.string(from: today)
    }
    
    var body: some View {
        
        let data: [sugarIntakeData] = [
            sugarIntakeData(day:"Sun", min: 0, intake: intTotalSugarIntake, limit: intSugarGoal),
            sugarIntakeData(day:"Mon", min: 0, intake: intTotalSugarIntake, limit: intSugarGoal),
            sugarIntakeData(day:"Tue", min: 0, intake: intTotalSugarIntake, limit: intSugarGoal),
            sugarIntakeData(day:"Wed", min: 0, intake: intTotalSugarIntake, limit: intSugarGoal),
            sugarIntakeData(day:"Thu", min: 0, intake: intTotalSugarIntake, limit: intSugarGoal),
            sugarIntakeData(day:"Fri", min: 0, intake: intTotalSugarIntake, limit: intSugarGoal),
            sugarIntakeData(day:"Sat", min: 0, intake: intTotalSugarIntake, limit: intSugarGoal)
            
        ]
        
        ZStack {
            VStack {
                // Fixed Header with Title
                ZStack {
                    Image("Logo Header")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 100)
                        .padding(.top, 40)
                }
                
                // ScrollView for the rest of the content
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Daily Tracker")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: "#ff66c4"))
                                HStack {
                                    Text("\(formattedSugarIntake) g")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(totalSugarIntake > sugarGoal ? Color.red : Color(hex: "#ff66c4"))
                                    
                                    Spacer()
                                    
                                    Text("Remaining: \(formattedSugar) g")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                }
                                .padding()
                                .background(isDarkMode ? Color.black : Color.white) // Background for Dark Mode
                                .cornerRadius(16)
                                .shadow(color: isDarkMode ? Color.black.opacity(0.5) : Color(hex: "#ffc1e3").opacity(0.5), radius: 4)
                                
                                HStack{
                                    Text("0%")
                                        .foregroundColor(isDarkMode ? .white : .black)
                                    
                                    Spacer()
                                    
                                    Text("\(Int(totalSugarIntake/sugarGoal*100))%")
                                        .fontWeight(.bold)
                                        .foregroundColor(totalSugarIntake > sugarGoal ? Color.red : Color(hex: "#ff66c4"))
                                    Spacer()
                                    
                                    Text("100%")
                                        .foregroundColor(isDarkMode ? .white : .black)
                                }
                                
                                // Progress Bar inside the same container frame
                                ZStack(alignment: .leading) {
                                    // Background of the progress bar (gray)
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 8)
                                        .frame(width: 340)
                                    
                                    
                                    // Foreground progress bar (colored) set to 50% width
                                    RoundedRectangle(cornerRadius: 4)
                                        .frame(width: min(totalSugarIntake / sugarGoal * 340, 340))
                                        .foregroundColor(totalSugarIntake > sugarGoal ? Color.red : Color(hex: "#ff66c4"))
                                }
                                .cornerRadius(4)
                                .padding(.bottom, 10)
                            }
                            .padding()
                            .background(isDarkMode ? Color.black : Color.white) // Container background
                            .cornerRadius(16)
                            .shadow(color: isDarkMode ? Color.black.opacity(0.5) : Color(hex: "#ffc1e3").opacity(0.5), radius: 4)
                        }
                        .padding(.horizontal)
                        
                        // Weekly Intake Bar Chart
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text("Weekly Intake")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: "#ff66c4"))
                            Spacer()
                            
                            ZStack{
                                HStack(alignment: .bottom, spacing: 10) {
                                    ForEach(data, id: \.day) { entry in
                                        VStack {
                                            Spacer()
                                            if entry.day == formattedTodayDate() {
                                                Rectangle()
                                                    .fill(totalSugarIntake > sugarGoal ? Color.red : Color(hex: "#ff66c4"))
                                                    .frame(width: 30, height: min( CGFloat(entry.intake), maxHeight))
                                                    .cornerRadius(5)
                                            }
                                            
                                            Text(entry.day) // Day label below each bar
                                                .font(.caption)
                                                .foregroundColor(.black)
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                }
                                .padding()
                                .frame(height: 120)
                                
                                
                                Rectangle()
                                           .fill(Color.green.opacity(0.8)) // Limit line color (green)
                                           .frame(height: 2) // Thin vertical line
                                           .position(x: 180, y: (-14 + maxHeight - (sugarGoal / maxHeight) * maxHeight))
                            }
                            
                        }
                        .padding()
                        .frame(width: 370, alignment: .leading)
                        .background(isDarkMode ? Color.black : Color.white) // Container background for Today Entries
                        .cornerRadius(16)
                        .shadow(color: isDarkMode ? Color.black.opacity(0.5) : Color(hex: "#ffc1e3").opacity(0.5), radius: 4)
                        
                        

                        
                        // Today Entries Section with Food Suggestions
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Today Entries")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: "#ff66c4"))
                            
                            if productData.products.isEmpty {
                                Text("No Entries")
                                    .foregroundColor(isDarkMode ? .white : .black)
                                    .font(.subheadline)
                                    .padding()
                            } else {
                                List(productData.products) { entry in
                                    HStack {
                                        Text(entry.name)
                                            .foregroundColor(isDarkMode ? .white : .black) // Text color change for Dark Mode
                                        
                                        Spacer()
                                        
                                        Text(String(format: "%.2f g", entry.sugarWeight))
                                            .foregroundColor(.gray)

                                    }
                                }
                                .listStyle(PlainListStyle())
                                .background(isDarkMode ? Color.black : Color.white) // List background for Dark Mode
                                .frame(height: 150)
                            }
                        }
                        .padding()
                        .frame(width: 370, alignment: .leading)
                        .background(isDarkMode ? Color.black : Color.white) // Container background for Today Entries
                        .cornerRadius(16)
                        .shadow(color: isDarkMode ? Color.black.opacity(0.5) : Color(hex: "#ffc1e3").opacity(0.5), radius: 4)
                        
                        
                    }
        
                }
            }
            .edgesIgnoringSafeArea(.top)
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

// Progress Bar view
struct ProgressBar: View {
    var progress: Double
    
    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 8)
            Capsule()
                .fill(Color(hex: "#ff66c4"))
                .frame(width: CGFloat(progress) * UIScreen.main.bounds.width, height: 8)
        }
        .cornerRadius(4)
    }
}

// Custom Hex Color Support
extension Color {
    init(hex: String) {
        var hexString = hex
        if hex.hasPrefix("#") {
            hexString = String(hex.dropFirst()) // Remove the #
        }
        
        let scanner = Scanner(string: hexString)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let red = Double((rgbValue >> 16) & 0xFF) / 255.0
        let green = Double((rgbValue >> 8) & 0xFF) / 255.0
        let blue = Double(rgbValue & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
                                            
                                            

#Preview {
    let mockData = ProductData()

    return ContentView()
        .environmentObject(mockData)
}
