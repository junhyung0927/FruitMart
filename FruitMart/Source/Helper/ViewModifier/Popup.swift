import SwiftUI

enum PopupStyle {
    case none
    case blur
    case dimmed
}

///ViewModifier 프로토콜 채택
fileprivate struct Popup<Message: View>: ViewModifier{
    ///팝업창의 크기
    let size: CGSize?
    /// 앞에서 정의한 팝업 스타일
    let style: PopupStyle
    ///팝업창에 나타낼 메시지
    let message: Message
    
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
        ///팝업창을 띄운 뷰
        content
            ///blur 스타일인 경우에만 적용
            .blur(radius: style == .blur ? 2 : 0)
            ///dimmed 스타일인 경우에만 적용
            .overlay(Rectangle()
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
                /// iOS 13과 iOS 14의 지오메트리 리더 뷰 정렬 위치가 달라졌으므로 조정
                .position(x: g.size.width / 2, y: g.size.height / 2)
        }
    }
    
    ///팝업창 상단에 위치한 체크 마크 심벌
    private var checkCircleMark: some View{
        Symbol("checkmark.circle.fill", color: .peach)
            .font(Font.system(size: 60).weight(.semibold))
            /// iOS 13과 14에서 크기 차이가 있어 조정
            .background(Color.white.scaleEffect(0.7))
            .offset(x: 0, y: -20)
    }
}

fileprivate struct PopupToggle: ViewModifier {
    ///true일 때만 팝업창 표현
    @Binding var isPresented: Bool
    func body(content: Content) -> some View {
        content
            .disabled(isPresented)
            ///팝업창 종료
            .onTapGesture{ self.isPresented.toggle() }
    }
}

///Identifiable 프로토콜을 준수하는 아이템이 주어졌을 때 관련된 팝업창 띄우도록 하는 함수
fileprivate struct PopupItem<Item: Identifiable>: ViewModifier {
    ///nil이 아니면 팝업 표시
    @Binding var item: Item?
    func body(content: Content) -> some View {
        content
            ///팝업이 떠 있는 동안 다른 뷰에 대한 상호 작용 비활성화
            .disabled(item != nil)
            ///팝업창 제거
            .onTapGesture{ self.item = nil }
    }
}

///.modifier 대신 popup 과 같이 익숙한 방식으로 사용할 수 있도록 뷰 프로토콜 확장
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
        ///nil이 아닐 때만 팝업창 띄우기
        if let selectedItem = item.wrappedValue {
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
            ///아이템이 있을 경우에만
            if isNonNil{
                Color.black
                    .luminanceToAlpha()
                    .popup(item: item, size: size, style: style, content: content)
                    .edgesIgnoringSafeArea(edges)
            }
        }
    }
}

















































