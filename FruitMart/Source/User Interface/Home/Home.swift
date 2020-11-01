//
//  ContentView.swift
//  FruitMart
//
//  Created by 조준형 on 2020/11/01.
//

import SwiftUI

struct Home: View {
//    let store: Store
    @EnvironmentObject private var store: Store
    
    var body: some View {
        NavigationView{
            List(store.products) { product in
                NavigationLink(destination: ProductDetailView(product: product)){
                    ProductRow(product: product)
                }
            }
            .navigationBarTitle("과일마트")
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Preview(source: Home())
            .environmentObject(Store())
    }
}
