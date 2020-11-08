import SwiftUI

struct OrderCompltedMessasge: View {
    var body: some View {
        Text("주문 완료 ! ")
            .font(.system(size:24))
            .bold()
            .kerning(2) //자간 조정
    }
}
