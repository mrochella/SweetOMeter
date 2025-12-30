import SwiftUI

@main
struct Sweet_o_meterApp: App {
    @StateObject private var productData = ProductData()

    var body: some Scene {
        WindowGroup {
            NavigationBar()
                .environmentObject(productData) // Provide the ProductData instance
        }
    }
}
