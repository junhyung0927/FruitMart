import SwiftUI

struct OrderCompltedMessasge: View {
    var body: some View {
        Text("주문 완료 ! ")
            .font(.system(size:24))
            .bold()
            ///자간 조정
            .kerning(2)
    }
}
