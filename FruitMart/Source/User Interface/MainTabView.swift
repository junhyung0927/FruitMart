import SwiftUI

struct MainTabView: View{
    private enum Tabs {
        ///4개의 탭 정의. 탭 뷰의 태그로 활용
        case home, recipe, gallery, myPage        
    }
    
    @State private var selectedTab: Tabs = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Group{
                home
                recipe
                gallery
                myPage
            }
            .accentColor(.primary)
        }
        .accentColor(.peach)
        ///selectedTab의 값이 recipe인 경우에만 상태 표시줄 숨김 처리
        .statusBar(hidden: selectedTab == .recipe)
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
        RecipeView()
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
