import Foundation

// Data model for a product
struct Product: Identifiable {
    let id = UUID() // Unique identifier for the product
    let name: String
    let sugarWeight: Double
}

// ObservableObject to manage product data
class ProductData: ObservableObject {
    @Published var products: [Product] = []
}
