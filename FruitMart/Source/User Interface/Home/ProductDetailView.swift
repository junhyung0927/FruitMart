//
//  ProductDetailView.swift
//  FruitMart
//
//  Created by 조준형 on 2020/11/01.
//

import SwiftUI

struct ProductDetailView: View{
    @State private var showingAlert: Bool = false
    @State private var quantity:Int = 1
    @EnvironmentObject private var store: Store
    
    let product: Product //상품 정보를 전달받기 위한 프로퍼티 선언
    
    var body: some View{
        VStack(spacing: 0){
            productImage //상품이미지
            orderView //상품 정보를 출력하고 그 상품을 주문하기 위한 뷰
        }
        .edgesIgnoringSafeArea(.top)
        .alert(isPresented: $showingAlert) { confirmAlert }
        //alert 수식어 추가
    }
    
    var productImage: some View{
        GeometryReader { _ in
            Image(self.product.imageName)
                .resizable()
                .scaledToFill()
        }
    }
    
    // 상품 설명과 주문하기 버튼 등을 모두 포함하는 컨테이너
    var orderView: some View{
        GeometryReader{
            VStack(alignment: .leading){
                self.productDescription // 상품명과 즐겨찾기 버튼(하트 모양) 이미지
                Spacer()
                self.priceInfo //가격 정보
                self.placeOrderButton //주문하기 버튼
            }
            //지오메트리 리더가 차지하는 뷰의 높이보다 VStack의 높이가 10 크도록 지정
            .frame(height: $0.size.height + 10)
            .padding(32)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.2), radius:10, x:0, y:-5)
        }
    }
    
    var productDescription: some View{
        VStack(alignment: .leading, spacing: 16){
            HStack{
                Text(product.name) //상품명
                    .font(.largeTitle).fontWeight(.medium)
                    .foregroundColor(.black)
                
                Spacer()
                
                //                Image(systemName: "heart") //즐겨 찾기 버튼
                //                    .imageScale(.large)
                //                    .foregroundColor(Color.peach)
                //                    .frame(width: 32, height: 32)
                
                FavoriteButton(product: product)
            }
            
            Text(splitText(product.description)) //상품 설명
                .foregroundColor(.secondaryText)
                .fixedSize()
        }
    }
    
    func splitText(_ text: String) -> String {
        //한 문장으로 길게 구성된 상품 설명 문장을 화면에 좀 더 적절하게 나타내기 위해 두 줄로 나누어 주는 기능을 하는 메서드
        guard !text.isEmpty else {return text}
        let centerIdx = text.index(text.startIndex, offsetBy: text.count / 2)
        let centerSpaceIdx = text[..<centerIdx].lastIndex(of: " ")
            ?? text[centerIdx...].firstIndex(of: " ")
            ?? text.index(before: text.endIndex)
        let afterSpaceIdx = text.index(after: centerSpaceIdx)
        let lhsString = text[..<afterSpaceIdx].trimmingCharacters(in: .whitespaces)
        let rhsString = text[..<afterSpaceIdx].trimmingCharacters(in: .whitespaces)
        return String(lhsString + "\n" + rhsString)
    }
    
    var priceInfo: some View {
        let price = quantity * product.price
        return HStack {
            (Text("₩")
                + Text("\(price)").font(.title)
            ).fontWeight(.medium)
            Spacer()
            QuantitySelector(quantity: $quantity)
        }
        .foregroundColor(.black)
    }
    
    var placeOrderButton: some View {
        Button(action: {
            self.showingAlert = true
        }) {
            Capsule()
                .fill(Color.peach)
                .frame(maxWidth: .infinity, minHeight: 30, maxHeight: 55)
                .overlay(Text("주문하기")
                            .font(.system(size: 20)).fontWeight(.medium)
                            .foregroundColor(Color.white))
                .padding(.vertical, 8)
        }
    }
    
    var confirmAlert: Alert{
        Alert(title: Text("주문 확인"),
              message: Text("\(product.name)을 \(quantity)개 구매하겠습니까?"),
              primaryButton: .default(Text("확인"), action: {
                self.placeOrder() //확인 버튼 눌렀을 때 동작하도록 구현
              }),
              secondaryButton: .cancel(Text("취소"))
        )
    }
    
    func placeOrder(){
        //상품과 수량 정보를 placeOrder 메서드에 인수로 전달
        store.placeOrder(product: product, quantity: quantity)
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let source1 = ProductDetailView(product: productSamples[0])
        let source2 = ProductDetailView(product: productSamples[1])
        
        return Group{
            //나머지 매개 변수 생략 시 총 4가지 환경에서의 프리뷰 출력
            Preview(source: source1)
            //아이폰 11 프로 + 라이트 모드 - 1가지 환경에서만 출력
            Preview(source: source2, devices: [.iPhone11Pro], displayDarkMode: false)
        }
    }
}
