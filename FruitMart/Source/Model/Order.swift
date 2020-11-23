import Foundation

struct Order {
    ///식별을 위한 Identifiable 프로토콜 채택
    static var orderSequence = sequence(first: lastOrderID + 1) { $0 &+ 1 }
    static var lastOrderID: Int {
        get { UserDefaults.standard.integer(forKey: "LastOrderID") }
        set { UserDefaults.standard.set(newValue, forKey: "LastOrderID") }
    }
    let id: Int
    let product: Product
    let quantitiy: Int
    
    var price: Int{
        product.price * quantitiy
    }
    
}

extension Order: Identifiable {}
extension Order: Codable {}

