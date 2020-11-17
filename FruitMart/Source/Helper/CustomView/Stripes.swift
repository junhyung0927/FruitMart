import SwiftUI

///View 대신 Shape 프로토콜 채택
///ForEach에서 데이터 구분을 위해 id 매개 변수에 전달하는 값은 Hashable 프로토콜을 준수해야한다.
struct Stripes: Shape, Hashable {
    ///줄무늬가 몇 개로 분할되어 보일 것인지 결정. 기본값 30
    var stripes: Int = 30
    ///삽입 , 제거 효과 구분
    var insertion: Bool = true
    ///화면 차지 비율 0.0 ~ 1.0
    var ratio: CGFloat
    
    var animatableData: CGFloat{
        ///애니메이션 연산에 rato 값 활용
        get { ratio }
        set { ratio = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        ///줄무늬 하나가 차지하는 너비 기본값 (전체 너비 / 줄무늬 개수)
        let stripeWidth = rect.width / CGFloat(stripes)
        let rects = (0..<stripes).map { (index: Int) -> CGRect in
            ///줄무늬 시작점 x 좌표
            let xOffset = CGFloat(index) * stripeWidth
            ///삽입될 뷰인지 제거될 뷰인지 구분하여 줄무늬 위치 조정
            let adjustment = insertion ? 0 : (stripeWidth * (1 - ratio))
            return CGRect(
                ///조정값을 더하여 최종 위치 결정
                x: xOffset + adjustment,
                y: 0,
                ///줄무늬 너비
                width: stripeWidth * ratio,
                height: rect.height
            )
        }
        ///만들어진 모든 줄무늬를 path에 추가
        path.addRects(rects)
        return path
    }
}



