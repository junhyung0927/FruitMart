import SwiftUI

struct ShrinkButtonStyle: ButtonStyle { //ButtonStyle 프로토콜 채택
    //버튼이 눌리고 있을 때 변화할 크기와 투명도 지정
    var minScale: CGFloat = 0.9
    var minOpacity: Double = 0.6
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label //기본 버튼 UI
            .scaleEffect(configuration.isPressed ? minScale: 1)
            .opacity(configuration.isPressed ? minOpacity: 1)
    }
}

