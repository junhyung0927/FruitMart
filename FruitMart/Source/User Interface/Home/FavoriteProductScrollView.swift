import SwiftUI

struct FavoriteProductScrollView: View {
    @EnvironmentObject private var store: Store
    ///즐겨찾기 상품 이미지 표시 여부
    @Binding var showingImage: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            ///뷰의 목적을 표현하는 제목
            title
            if showingImage {
                ///즐겨찾기 한 상품 목록
                products
            }
        }
        .padding()
        .transition(.slide)
    }
    
    var title: some View {
        HStack(alignment: .top, spacing: 5){
            Text("즐겨찾는 상품")
                .font(.headline).fontWeight(.medium)
            
            Symbol("arrowtriangle.up.square")
                .padding(4)
                .rotationEffect(Angle(radians: showingImage ? .pi : 0))
            Spacer()
        }
        
        .padding(.bottom, 8)
        ///이미지 표시 여부 변경
        .onTapGesture {
            withAnimation {
                self.showingImage.toggle()
            }
            
        }
        
    }
    
    var products: some View {
        ///즐겨찾기 상품 목록 읽어오기
        let favoriteProducts = store.products.filter{ $0.isFavorite }
        return ScrollView(.horizontal, showsIndicators: false) {
            ///인디케이터 미표시
            HStack(spacing: 0) {
                ForEach(favoriteProducts) { product in
                    ///상품 선택 시, 해당 상품에 대한 상세 화면으로 이동하도록 내비게이션 링크로 연결
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        self.eachProduct(product)
                    }
                }
            }
        }
        .animation(.spring(dampingFraction: 0.78))
    }
    
    func eachProduct(_ product: Product) -> some View {
        /// 스크롤 뷰 내에서 위치 정보를 얻도록 지오메트리 리더 사용
        GeometryReader {
            ResizedImage(product.imageName, rederingMode: .original)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .frame(width: 90, height: 90)
                ///스크롤 위치에 따라 크기 조정
                .scaleEffect(self.scaledValue(from: $0))
        }
        .frame(width: 105, height: 105)
    }
    
    func scaledValue(from geometry: GeometryProxy) -> CGFloat {
        let xOffset = geometry.frame(in: .global).minX - 16
        ///최소 크기: 원래 크기의 0.9
        let minSize: CGFloat = 0.9
        ///최대 크기: 원래 크기의 1.1
        let maxSize: CGFloat = 1.1
        /// 변화폭 0.2
        let delta: CGFloat = maxSize - minSize
        
        let size = minSize + delta * ( 1 - xOffset / UIScreen.main.bounds.width)
        return max(min(size, maxSize), minSize)
    }
}
