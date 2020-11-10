import SwiftUI

struct FavoriteButton: View {
    @EnvironmentObject private var store: Store
    let product: Product
    
    private var imageName: String {
        ///즐겨찾기 여부에 따라 심벌 변경
        product.isFavorite ? "heart.fill" : "heart"
    }
    
    var body: some View {
        
        Button(action: {
            self.store.toggleFavorite(of: self.product)
        }) {
            
//            Image(systemName: imageName)
//                .imageScale(.large)
//                .foregroundColor(.peach)
//                .frame(width: 32, height: 32)
//                .onTapGesture { self.store.toggleFavorite(of: product)}
            
            ///상품에 대한 즐겨찾기 설명 변경
            Symbol(imageName, scale: .large, color: .peach)
                .frame(width: 32, height: 32)
                .onTapGesture { self.store.toggleFavorite(of: self.product)}
        }
    }
    
}
