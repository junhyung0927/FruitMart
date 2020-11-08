import SwiftUI

struct ResizedImage: View {
    let imageNmae: String
    let contentMode: ContentMode
    let renderingMode: Image.TemplateRenderingMode?
    
    init(
        _ imageName: String,
        contentMode: ContentMode = .fill,
        rederingMode: Image.TemplateRenderingMode? = nil
    ) {
        self.imageNmae = imageName
        self.contentMode = contentMode
        self.renderingMode = rederingMode
    }
    
    var body: some View {
        Image(imageNmae)
            .renderingMode(renderingMode)
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}
