import SwiftUI

struct MainTabView: View{
    private enum Tabs {
        case home, recipe, gallery, myPage
        //4개의 탭 정의. 탭 뷰의 태그로 활용
    }
    
    @State private var selectedTab: Tabs = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            home
            recipe
            gallery
            myPage
        }
        
    }
}

fileprivate extension View {
    func tabItem(image: String, text: String) -> some View {
        self.tabItem {
            Symbol(image, scale: .large)
                .font(Font.system(size: 17, weight: .light))
            Text(text)
        }
    }
}

private extension MainTabView{
    var home: some View{
        Home()
            .tag(Tabs.home)
            .tabItem(image: "house", text: "홈")
    }
    
    var recipe: some View {
        Text("레시피")
            .tag(Tabs.recipe)
            .tabItem(image: "book", text: "레시피")
    }
    
    var gallery: some View {
        Text("이미지 갤러리")
            .tag(Tabs.gallery)
            .tabItem(image: "photo.on.rectangle", text: "갤러리")
    }
    
    var myPage: some View {
        Text("마이페이지")
            .tag(Tabs.myPage)
            .tabItem(image: "person", text: "마이페이지")
    }
}

struct MainTabView_Previews: PreviewProvider {
  static var previews: some View {
    Preview(source: MainTabView())
      .environmentObject(Store())
  }
}
