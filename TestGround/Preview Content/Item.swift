//
//  FoodItem.swift
//  TestGround
//
//  Created by User on 25/07/2024.
//

import Foundation

struct FoodItem: Identifiable {
    var id = UUID().uuidString
    let title: String
    let description: String
    let price: String
    let imageName: String
}

