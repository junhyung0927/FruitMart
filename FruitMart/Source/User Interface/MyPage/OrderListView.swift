import SwiftUI

struct OrderListView: View {
    ///주문 정보를 가지는 변수
    @EnvironmentObject var store: Store
    @Environment(\.editMode) var editMode
    
    var body: some View {
        ZStack{
            if store.orders.isEmpty {
                ///주문 내역이 없을 때 표시
                emptyOrders
            } else {
                ///주문 내역이 있을 때 표시
                orderList
            }
        }
        ///뷰가 전환될 때 애니메이션 적용
        .animation(.default)
        .navigationBarTitle("주문 목록")
        ///에디트 버튼 추가
        .navigationBarItems(trailing: editButton)
    }
    
    var emptyOrders: some View {
        VStack(spacing: 25) {
            ///에셋에 포함된 박스 이미지
            Image("box")
                .renderingMode(.template)
                .foregroundColor(Color.gray.opacity(0.4))
            
            Text("주문 내역이 없습니다.")
                .font(.headline).fontWeight(.medium)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
    
    var orderList: some View {
        List {
            ForEach(store.orders) {
                OrderRow(order: $0)
            }
            .onDelete(perform: store.deleteOrder(at:))
            .onMove(perform: store.moveOrder(from:to:))
        }
    }
    
    var editButton: some View {
        !store.orders.isEmpty
            ///주문 내역이 있을 때
            ? AnyView(EditButton())
            ///주문 내역이 없을 때
            : AnyView(EmptyView())
    }
}
