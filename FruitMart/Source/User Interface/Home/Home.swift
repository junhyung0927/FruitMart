//
//  ContentView.swift
//  FruitMart
//
//  Created by 조준형 on 2020/11/01.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject private var store: Store
    @State private var quickOrder: Product? //빠른 주문 기능으로 주문한 상품 저장
    @State private var showingFavoriteImage: Bool = true
    
    var body: some View {
        NavigationView{
            VStack{
                //즐겨찾기 상품이 없다면 무시
                if showFavorite {
                    favoriteProducts //구현해 둔 스크롤 뷰에 해당하는 프로퍼티
                }
                darkerDivider
                productList // 기존에 있던 코드를 프로퍼티로 추출
            }
            .navigationBarTitle("과일마트")
        }
        .popupOverContext(item: $quickOrder, style: .blur,content: popupMessage(product:))
    }
    
    func popupMessage(product: Product) -> some View {
        let name = product.name.split(separator: " ").last!
        return VStack{
            Text(name)
                .font(.title).bold().kerning(3)
                .foregroundColor(.peach)
                .padding()
            
            OrderCompltedMessasge()
        }
    }
    
    //즐겨찾기 상품 목록
    var favoriteProducts: some View {
        FavoriteProductScrollView(showingImage: $showingFavoriteImage)
            .padding(.top, 24)
            .padding(.bottom, 8)
    }
    
    //커스텀 구분선
    var darkerDivider: some View{
        Color.primary
            .opacity(0.3)
            .frame(maxWidth: .infinity, maxHeight: 1)
            
    }
    
    //body에 작성되어 있던 기존 코드 추출
    var productList: some View{
        List(store.products) { product in
            NavigationLink(destination: ProductDetailView(product: product)){
                ProductRow(product: product, quickOrder: self.$quickOrder)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    //즐겨찾기 상품 유무 확인
    var showFavorite: Bool{
        !store.products.filter({ $0.isFavorite}).isEmpty
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Preview(source: Home())
            .environmentObject(Store())
    }
}
