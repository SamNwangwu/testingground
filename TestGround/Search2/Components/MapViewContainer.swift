//
//  MapViewContainer.swift
//  TestGround
//
//  Created by User on 24/07/2024.
//
import SwiftUI
import MapKit

struct MapViewContainer: View {
    @Environment(\.dismiss) var dismiss
    @State private var userLocation: CLLocationCoordinate2D?
    @State private var zoomToUser: Bool = false

    var body: some View {
        ZStack {
            MapView(userLocation: $userLocation, zoomToUser: $zoomToUser)
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .padding()
                            .background(Color.white.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .padding()

                    Spacer()
                }

                Spacer()

                Button(action: {
                    zoomToUser = true
                }) {
                    Image(systemName: "location.fill")
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .clipShape(Circle())
                }
                .padding()
            }
        }
    }
}
