import SwiftUI

struct MyPage: View {
    ///앱 설정에 접근하기 위해 추가
    @EnvironmentObject var store: Store
    ///피커 선택지
    private let pickerDataSource: [CGFloat] = [140,150,160]
    
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
            
            productHeightPicker
        }
    }
    
    var productHeightPicker: some View {
        VStack(alignment: .leading){
            ///피커의 제목 역할을 대신 수행
            Text("상품 이미지 높이 조절")
            
            ///SegmentedPickerStyle을 사용할 때는 피커 제목에 빈 문자열을 전달해도 무방
            
            ///피커에서 선택한 값을 appSetting의 productRowHeight 와 연동
            Picker("상품 이미지 높이 조절", selection: $store.appSetting.productRowHeight) {
                ForEach(pickerDataSource, id: \.self) {
                    ///포맷을 이용해 소수점 제거
                    Text(String(format: "%.0f", $0)).tag($0)
                }
            }
            ///피커 스타일 변경
            .pickerStyle(SegmentedPickerStyle())
        }
        .frame(height: 72)
    }
}
