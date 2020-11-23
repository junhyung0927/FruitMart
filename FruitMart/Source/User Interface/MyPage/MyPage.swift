import SwiftUI

struct MyPage: View {
    ///앱 설정에 접근하기 위해 추가
    @EnvironmentObject var store: Store
    
    var body: some View {
        NavigationView {
            ///폼을 이용해 마이페이지 메뉴 그룹화
            Form {
                orderInfoSection
                ///앱 설정 섹션
                appSettingSection
            }
            .navigationBarTitle("마이페이지")
        }
    }
}

extension MyPage {
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
    
    var appSettingSection: some View {
        Section(header: Text("앱 설정").fontWeight(.medium)) {
            Toggle("즐겨찾는 상품 표시", isOn: $store.appSetting.showFavoriteList)
                .frame(height: 44)
        }
    }
    
}
