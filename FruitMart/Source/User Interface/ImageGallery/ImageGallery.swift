import SwiftUI


struct ImageGallery: View{
    ///앱의 다른 부분에는 영향이 없도록 별도의 상품 목록을 저장하여 사용
    static private let galleryImages: [String] = Store().products.map { $0.imageName }
    @State private var productImages: [String] = galleryImages
    @State private var spacing: CGFloat = 20
    @State private var scale: CGFloat = 0.020
    @State private var angle: CGFloat = 5
    @GestureState private var translation: CGSize = .zero
    
    var body: some View{
        VStack {
            //카드 이미지가 중간 부근에 나타나도록 화면 상단에 공간 확보
            Spacer()
            ZStack{
                ///상품 목록 순서대로 표시되는 이미지
                backgroundCards
                ///가장 전면에서 보이게 될 이미지
                frontCard
            }
            ///카드 이미지와 컨트롤러 간 공간 확보
            Spacer()
            ///이미지가 보일 간격, 크기, 각도를 조정하는 컨트롤러
            controller
        }
        .edgesIgnoringSafeArea(.top)
    }
}

private extension ImageGallery {
    var frontCard: some View {
        let dragGesture = DragGesture()
            .updating($translation) { (value, state, _) in
                state = value.translation
        }
        
        /// 상품 목록의 첫 이미지
        return FruitCard(productImages[0])
            ///드래그한 위치를 따라서 이동
            .offset(translation)
            .shadow(radius: 4, x: 2, y: 2)
            .onLongPressGesture(perform: {
                self.productImages.append(self.productImages.removeFirst())
            })
            .simultaneousGesture(dragGesture)
    }
    
    var backgroundCards: some View {
        ForEach(productImages.dropFirst().reversed(), id: \.self){
            self.backgroundCard(image: $0)
        }
    }
    
    var controller: some View {
        let titles = ["간격", "크기", "각도"]
        let values = [$spacing, $scale, $angle]
        ///순서대로 간격, 크기, 각도에 대한 최소, 최대 범위
        let ranges: [ClosedRange<CGFloat>] = [1.0...40.0, 0...0.05, -90.0...90.0]
        
        return VStack{
            ForEach(titles.indices) { i in
                HStack{
                    Text(titles[i])
                        .font(.system(size: 17))
                        .frame(width: 80)
                    Slider(value: values[i], in: ranges[i])
                        .accentColor(Color.gray.opacity(0.25))
                }
            }
        }
        .padding()
    }
    
    func backgroundCard(image: String) -> some View {
        ///인덱스 계산
        let index = productImages.firstIndex(of: image)!
        let response = computeResponse(index: index)
        let animation = Animation.spring(response: response, dampingFraction: 0.68)
        return FruitCard(image)
            .shadow(color: .primaryShadow, radius: 2, x: 2, y: 2)
            .offset(computePosition(index: index))
            .scaleEffect(computeScale(index: index))
            .rotation3DEffect(computeAngle(index: index), axis: (0,0,1))
            .transition(AnyTransition.scale.animation(animation))
            .animation(animation)
    }
    
    func computePosition(index: Int) -> CGSize {
        let x = translation.width
        let y = translation.height - CGFloat(index) * spacing
        
        return CGSize(width: x, height: y)
    }
    
    func computeScale(index: Int) -> CGFloat {
        let cardScale = 1.0 - CGFloat(index) * (0.05 - scale)
        return max(cardScale, 0.1)
    }
    
    func computeAngle(index: Int) -> Angle {
        let degrees = Double(index) * Double(angle)
        return Angle(degrees: degrees)
    }
    
    func computeResponse(index: Int) -> Double {
      max(Double(index) * 0.04, 0.2)
    }
}
