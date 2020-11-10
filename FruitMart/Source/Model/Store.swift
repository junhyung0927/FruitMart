import Foundation

final class Store : ObservableObject{
    @Published var products: [Product]
    ///전체 주문 목록
    @Published var orders: [Order] = []
    
    init(filename: String = "ProductData.json") {
        self.products = Bundle.main.decode(filename: filename, as : [Product].self)
    }
    
    ///어떤 상품을 받으면 placeOrder 메서드에 주문한 상품과 수량 정보를 받아서 orders 프로퍼티에 저장된다.
    func placeOrder(product: Product, quantity: Int){
        let nextID = Order.orderSequence.next()!
        let order = Order(id: nextID, product: product, quantitiy: quantity)
        orders.append(order)
        
        print(orders)
    }
}
extension Store{
    func toggleFavorite(of product: Product) {
      guard let index = products.firstIndex(of: product) else { return }
      products[index].isFavorite.toggle()
    }
}
 
