//
//  ProductRow.swift
//  2th_challenge
//
//  Created by 조준형 on 2020/10/28.
//

import SwiftUI

struct ProductRow: View {
    let product: Product
    
    var body: some View {
        HStack{
            productImage
            productDescription
        }
        .frame(height: 150)
        .background(Color.primary.colorInvert())
        .cornerRadius(6)
        .shadow(color: Color.primaryShadow, radius:1, x:2, y:2)
        .padding(.vertical, 8)
    }
}

private extension ProductRow{
    var productImage: some View{
        Image(product.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 140)
            .clipped()
    }
    
    var productDescription: some View{
        VStack{
            //상품명
            VStack( alignment: .leading){
                Text(product.name)
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding(.bottom, 6)
                
                //상품 설명
                Text(product.description)
                    .font(.footnote)
                    .foregroundColor(Color.secondaryText)
                
                Spacer()
                footerView
            }
        }
        .padding([.leading, .bottom], 12)
        .padding([.top, .trailing])
    }
    
    var footerView: some View{
        HStack(spacing: 0){
            //가격정보와 버튼
            Text("$").font(.footnote)
                + Text("\(product.price)").font(.headline)
            
            Spacer()
            //스택에서 view들 사이의 공간을 추가하기 위한 컴포넌트. 최솟값만 지정할 수 있다.
            //간격은 최솟값을 지키면서 부모 스택의 width와 함께 추가된 view에 따라서 자유자재로 늘어나거나 줄어든다.
            
            Image(systemName: "heart")
                .imageScale(.large)
                .foregroundColor(Color.peach)
                .frame(width: 32, height: 32)
            
            Image(systemName: "cart")
                .foregroundColor(Color.peach)
                .frame(width: 32, height: 32)
        }
    }
}


struct ProductRow_Previews: PreviewProvider {
    static var previews: some View{
        Group{
            ForEach(productSamples){
                ProductRow(product: $0)
            }
            ProductRow(product: productSamples[0])
                .preferredColorScheme(.dark)
        }
        .padding()
        .previewLayout(.sizeThatFits)
        //sizeThatFits를 이용하여 보더라도 약간의 여백을 주도록 추가
        //콘텐츠 크기에 맞춰서 프리뷰 컨테이너 크기 조정
    }
}
