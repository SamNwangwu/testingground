//
//  SubMenuOffsetModifier.swift
//  TestGround
//
//  Created by User on 26/07/2024.
//

import SwiftUI

struct SubMenuOffsetModifier: ViewModifier {
    let option: SubMenuOptions
    @Binding var currentOption: SubMenuOptions

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: SubMenuOffsetKey.self, value: proxy.frame(in: .named("scroll")))
                }
            )
            .onPreferenceChange(SubMenuOffsetKey.self) { proxy in
                let offset = proxy.minY
                withAnimation {
                    currentOption = (offset < 20 && -offset < (proxy.midX / 2) && currentOption != option)
                    ? option : currentOption
                }
            }
    }
}

