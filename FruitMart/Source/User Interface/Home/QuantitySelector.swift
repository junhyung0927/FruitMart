import SwiftUI

struct QuantitySelector : View{
    @Binding var quantity: Int
    var range: ClosedRange<Int> = 1...20
    // 수량 선택 가능 범위
    
    var body: some View{
        HStack{
            Button(action: {self.changeQuantity(-1) }){
                Image(systemName: "minus.circle.fill")
                    .imageScale(.large)
                    .padding()
            }
            .foregroundColor(Color.gray.opacity(0.5))
            //수량 감소 버튼
            
            Text("\(quantity)")
                .bold()
                .font(Font.system( .title, design: .monospaced))
                .frame(minWidth: 40, maxWidth: 60)
            //현재 수량을 나타낼 텍스트
            
            Button(action: {self.changeQuantity(1) }) {
                Image(systemName: "plus.circle.fill")
                    .imageScale(.large)
                    .padding()
            }
            .foregroundColor(Color.gray.opacity(0.5))
            //수량 증가 버튼
        }
    }
    
    private func changeQuantity(_ num: Int){
        if range ~= quantity + num {
            quantity += num
        }
    }
}

struct QuantitySelector_Preview: PreviewProvider {
    @State private var quantity = 0
    static var previews: some View{
        Group{
            QuantitySelector(quantity: .constant(1))
            QuantitySelector(quantity: .constant(10))
            QuantitySelector(quantity: .constant(20))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
