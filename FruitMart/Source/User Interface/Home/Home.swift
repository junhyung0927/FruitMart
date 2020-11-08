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
    
    var body: some View {
        NavigationView{
            List(store.products) { product in
                NavigationLink(destination: ProductDetailView(product: product)){
                    ProductRow(product: product, quickOrder: self.$quickOrder)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .navigationBarTitle("과일마트")
        }
        .popup(item: $quickOrder, content: popupMessage(product:))
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
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Preview(source: Home())
            .environmentObject(Store())
    }
}
