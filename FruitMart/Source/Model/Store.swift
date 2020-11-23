import Foundation

final class Store : ObservableObject{
    @Published var products: [Product]
    ///전체 주문 목록
    @Published var orders: [Order] = [] {
        didSet { saveData(at: ordersFilePath, data: orders) }
    }
    
    init(filename: String = "ProductData.json") {
        self.products = Bundle.main.decode(filename: filename, as : [Product].self)
        self.orders = loadData(at: ordersFilePath, type: [Order].self)
    }
    
    ///어떤 상품을 받으면 placeOrder 메서드에 주문한 상품과 수량 정보를 받아서 orders 프로퍼티에 저장된다.
    func placeOrder(product: Product, quantity: Int){
        let nextID = Order.orderSequence.next()!
        let order = Order(id: nextID, product: product, quantitiy: quantity)
        orders.append(order)
        
        print(orders)
        
        Order.lastOrderID = nextID
    }
}
extension Store{
    func toggleFavorite(of product: Product) {
      guard let index = products.firstIndex(of: product) else { return }
      products[index].isFavorite.toggle()
    }
}
 
// MARK: - File Handelr

private extension Store {
    var ordersFilePath: URL {
        ///Library 디렉터리에 있는 ApplicationSupport 디렉터리 URL
        let fileManager = FileManager.default
        
        let appSupportDir = fileManager.urls(for: .applicationSupportDirectory,
                                         in: .userDomainMask).first!
        
        ///번들 ID를 서브 디렉토리에 추가
        let bundleID = Bundle.main.bundleIdentifier ?? "FruitMart"
        let appDir = appSupportDir
            .appendingPathComponent(bundleID, isDirectory: true)
        
        ///디렉터리가 없으면 생성
        if !fileManager.fileExists(atPath: appDir.path) {
            try? fileManager.createDirectory(at: appDir,
                                         withIntermediateDirectories: true)
        }
        
        return appDir
            .appendingPathComponent("Orders")
            .appendingPathExtension("json")
    }
    
    func saveData<T>(at path: URL, data: T) where T:Encodable {
        do {
            ///부호화
            let data = try JSONEncoder().encode(data)
            ///파일로 저장
            try data.write(to: path)
        } catch {
            print(error)
        }
    }
    
    func loadData<T>(at path: URL, type: [T].Type) -> [T] where T: Decodable {
        do {
            ///파일 읽어오기
            let data = try Data(contentsOf: path)
            ///복호화
            let decodeData = try JSONDecoder().decode(type, from: data)
            return decodeData
        } catch {
            return []
        }
    }
}
