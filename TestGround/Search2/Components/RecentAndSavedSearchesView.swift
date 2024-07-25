//
//  RecentAndSavedSearchesView.swift
//  TestGround
//
//  Created by User on 24/07/2024.
//

import SwiftUI

struct RecentAndSavedSearchesView: View {
    @Binding var selectedTab: String

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    selectedTab = "Recent"
                }) {
                    Text("Recent")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                        .overlay(
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(selectedTab == "Recent" ? .black : .clear),
                            alignment: .bottomLeading
                        )
                }
                Button(action: {
                    selectedTab = "Saved"
                }) {
                    Text("Saved")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                        .foregroundColor(selectedTab == "Saved" ? .black : .gray)
                        .overlay(
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(selectedTab == "Saved" ? .black : .clear),
                            alignment: .bottomLeading
                        )
                }
                Spacer()
            }
            .padding(.top, 16)
            
            Spacer()
        }
    }
}

struct RecentAndSavedSearchesView_Previews: PreviewProvider {
    static var previews: some View {
        RecentAndSavedSearchesView(selectedTab: .constant("Recent"))
    }
}
