//
//  FruitMartApp.swift
//  FruitMart
//
//  Created by 조준형 on 2020/11/01.
//

import SwiftUI

@main
struct FruitMartApp: App {
    var body: some Scene {
        WindowGroup {
            let rootView = Home(store: Store())
        }
    }
}
