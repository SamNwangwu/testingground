//
//  SubMenuOffsetKey.swift
//  TestGround
//
//  Created by User on 26/07/2024.
//

import SwiftUI

struct SubMenuOffsetKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}


