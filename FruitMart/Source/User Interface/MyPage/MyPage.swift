import SwiftUI

struct MyPage: View {
    var body: some View {
        NavigationView {
            ///폼을 이용해 마이페이지 메뉴 그룹화
            Form {
                orderInfoSection
            }
            .navigationBarTitle("마이페이지")
        }
    }
    
    var orderInfoSection: some View {
        ///섹션을 사용해 이후에 추가될 다른 메뉴와 구분
        Section(header: Text("주문 정보").fontWeight(.medium)) {
            ///목적지 변경
            NavigationLink(destination: OrderListView()){
                Text("주문 목록")
            }
            ///높이 지정
            .frame(height: 44)
        }
    }
    
}
