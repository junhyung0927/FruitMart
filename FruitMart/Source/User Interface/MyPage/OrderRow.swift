import SwiftUI

struct OrderRow: View {
    ///주문 정보
    let order: Order
    
    var body: some View {
        HStack {
            ///상품 이미지
            ResizedImage(order.product.imageName)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                ///상품명
                Text(order.product.name)
                    .font(.headline).fontWeight(.medium)
                /// '주문 가격 | 주문 수량' 표시
                
                Text("$\(order.price) | \(order.quantitiy)개")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .frame(height: 100)
    }
}
