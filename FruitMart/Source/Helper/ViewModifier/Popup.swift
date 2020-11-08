import SwiftUI

enum PopupStyle {
    case none
    case blur
    case dimmed
}

fileprivate struct Popup<Message: View>: ViewModifier{ //ViewModifier 프로토콜 채택
    let size: CGSize? //팝업창의 크기
    let style: PopupStyle // 앞에서 정의한 팝업 스타일
    let message: Message //팝업창에 나타낼 메시지
    
    init(
        size: CGSize? = nil,
        style: PopupStyle = .none,
        message: Message
    ) {
        self.size = size
        self.style = style
        self.message = message
    }
    
    func body(content: Content) -> some View {
        content //팝업창을 띄운 뷰
            .blur(radius: style == .blur ? 2 : 0) //blur 스타일인 경우에만 적용
            .overlay(Rectangle() //dimmed 스타일인 경우에만 적용
                        .fill(Color.black.opacity(style == .dimmed ? 0.4 : 0)))
            .overlay(popupContent)
    }
    
    private var popupContent: some View {
        GeometryReader { g in
            VStack { self.message }
                .frame(width: self.size?.width ?? g.size.width * 0.6,
                       height: self.size?.height ?? g.size.height * 0.25)
                .background(Color.primary.colorInvert())
                .cornerRadius(12)
                .shadow(color: .primaryShadow, radius: 15, x: 5, y: 5)
                .overlay(self.checkCircleMark, alignment: .top)
                // iOS 13과 iOS 14의 지오메트리 리더 뷰 정렬 위치가 달라졌으므로 조정
                .position(x: g.size.width / 2, y: g.size.height / 2)
        }
    }
    
    //팝업창 상단에 위치한 체크 마크 심벌
    private var checkCircleMark: some View{
        Symbol("checkmark.circle.fill", color: .peach)
            .font(Font.system(size: 60).weight(.semibold))
            // iOS 13과 14에서 크기 차이가 있어 조정
            .background(Color.white.scaleEffect(0.7))
            .offset(x: 0, y: -20)
    }
}

fileprivate struct PopupToggle: ViewModifier {
    @Binding var isPresented: Bool //true일 때만 팝업창 표현
    func body(content: Content) -> some View {
        content
            .disabled(isPresented)
            .onTapGesture{ self.isPresented.toggle() } //팝업창 종료
    }
}

//Identifiable 프로토콜을 준수하는 아이템이 주어졌을 때 관련된 팝업창 띄우도록 하는 함수
fileprivate struct PopupItem<Item: Identifiable>: ViewModifier {
    @Binding var item: Item? //nil이 아니면 팝업 표시
    func body(content: Content) -> some View {
        content
            .disabled(item != nil) //팝업이 떠 있는 동안 다른 뷰에 대한 상호 작용 비활성화
            .onTapGesture{ self.item = nil } //팝업창 제거
    }
}

//.modifier 대신 popup 과 같이 익숙한 방식으로 사용할 수 있도록 뷰 프로토콜 확장
extension View{
    func popup<Content: View>(
        isPresented: Binding<Bool>,
        size: CGSize? = nil,
        style: PopupStyle = .none,
        @ViewBuilder content: () -> Content
    ) -> some View {
        if isPresented.wrappedValue {
            let popup = Popup(size: size, style: style, message: content())
            let popupToggle = PopupToggle(isPresented: isPresented)
            let modifiedContent = self.modifier(popup).modifier(popupToggle)
            return AnyView(modifiedContent)
        } else {
            return AnyView(self)
        }
    }
    
    func popup<Content: View, Item: Identifiable>(
        item: Binding<Item?>,
        size: CGSize? = nil,
        style: PopupStyle = .none,
        @ViewBuilder content: (Item) -> Content
    ) -> some View{
        if let selectedItem = item.wrappedValue { //nil이 아닐 때만 팝업창 띄우기
            let content = content(selectedItem)
            let popup = Popup(size: size, style: style, message: content)
            let popupItem = PopupItem(item: item)
            let modifiedContent = self.modifier(popup).modifier(popupItem)
            return AnyView(modifiedContent)
        } else {
            return AnyView(self)
        }
    }
    
    func popupOverContext<Item: Identifiable, Content: View>(
        item: Binding<Item?>,
        size: CGSize? = nil,
        style: PopupStyle = .none,
        ignoringEdges edges: Edge.Set = .all,
        @ViewBuilder content: (Item) -> Content
    ) -> some View {
        let isNonNil = item.wrappedValue != nil
        return ZStack{
            self
                .blur(radius: isNonNil && style == .blur ? 2 : 0)
            
            if isNonNil{ //아이템이 있을 경우에만
                Color.black
                    .luminanceToAlpha()
                    .popup(item: item, size: size, style: style, content: content)
                    .edgesIgnoringSafeArea(edges)
            }
        }
    }
}

















































