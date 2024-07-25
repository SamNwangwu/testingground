//
//  ContentView.swift
//  TestGround
//
//  Created by User on 25/07/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedOption: MenuBarOptions = .food
    @State private var currentOption: MenuBarOptions = .food
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Button {
                    
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                }
                
                Text("Hawksmoor - Wood Wharf")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                }
                
            }
            .padding(.horizontal)
            .foregroundStyle(.black)
            
            MenuOptionsList(selectedOption: $selectedOption, currentOption: $currentOption)
                .padding([.top, .horizontal])
                .overlay(
                Divider()
                    .padding(.horizontal, -16)
                , alignment: .bottom
                )
            
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators:  false) {
                    VStack {
                        ForEach(MenuBarOptions.allCases, id: \.self) { option in
                            MenuItemSection(option: option, currentOption: $currentOption)
                        }
                    }
                    .onChange(of: selectedOption, perform: { _ in
                        withAnimation(.easeInOut) {
                            proxy.scrollTo(selectedOption, anchor: .topTrailing)
                        }
                    })
                    .padding(.horizontal)
                }
                .coordinateSpace(name: "scroll")
            }
        }
    }
}

#Preview {
    ContentView()
}
