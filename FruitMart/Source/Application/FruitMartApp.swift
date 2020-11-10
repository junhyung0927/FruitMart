//
//  FruitMartApp.swift
//  FruitMart
//
//  Created by 조준형 on 2020/11/01.
//

import SwiftUI

@main
struct FruitMartApp: App{
    var body: some Scene {
        ///WindowGroup은 SwiftUI View를 담고 있는 container scene 같은 것.
        WindowGroup {
            let rootView = MainTabView()
                .environmentObject(Store())
        }
    }
    
    ///ios 14 SwiftUI
    init(){
        
        ///large 디스플레이 모드에서 적용
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor(named: "peach")!
        ]
        
        ///inline 디스플레이 모드일 때 사용
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor(named: "peach")!
        ]
        
        UITableView.appearance().backgroundColor = .clear
    }
}
