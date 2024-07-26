//
//  MainMenuOffsetModifier.swift
//  TestGround
//
//  Created by User on 26/07/2024.
//

import SwiftUI

struct MainMenuOffsetModifier: ViewModifier {
    let option: MenuBarOptions
    @Binding var currentOption: MenuBarOptions

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: MainMenuOffsetKey.self, value: proxy.frame(in: .named("scroll")))
                }
            )
            .onPreferenceChange(MainMenuOffsetKey.self) { proxy in
                let offset = proxy.minY
                withAnimation {
                    currentOption = (offset < 20 && -offset < (proxy.midX / 2) && currentOption != option)
                    ? option : currentOption
                }
            }
    }
}

