import SwiftUI

///shape 프로퍼티에 전달된 뷰의 모습대로 오려 낸 결과를 반환해준다.
struct ShapeClipModifier<S: Shape>: ViewModifier {
    let shape: S
    
    func body(content: Content) -> some View {
        content
            .clipShape(shape)
    }
}


struct ShapeClipModifier_Previews: PreviewProvider {
    static var previews: some View {
        ///화면 전환 비율. 0.1이면 삽입될 뷰는 10%, 제거될 뷰는 90%가 보이는 상태
        let ratio: [CGFloat] = [0.1, 0.3, 0.5, 0.7 ,0.9]
        ///뷰가 삽입되는 과정에서 변화하는 모습을 확인하는 배열
        let insertion = ratio.map { Stripes(ratio: $0) }
        ///뷰가 제거되는 과정에서 변화하는 모습을 확인하는 배열
        let removal = ratio.map {
            Stripes(insertion: false, ratio: 1 - $0)
        }
        let image = ResizedImage(recipeSamples[0].imageName,
                                 contentMode: .fit)
        
        return HStack{
            ForEach([insertion, removal], id: \.self) { type in
                VStack {
                    ForEach(type, id: \.self){
                        image.modifier(ShapeClipModifier(shape: $0))
                    }
                }
            }
        }
    }
}
