//
//  TestGroundApp.swift
//  TestGround
//
//  Created by User on 20/07/2024.
//
import SwiftUI
import GooglePlaces
import Photos

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    GMSPlacesClient.provideAPIKey("AIzaSyDZdzqDwtaIe2lesCU9vX74tpDgixpqzyY")
    return true
  }
}

@main
struct TestGroundApp: App {
    @State private var selectedAssets = [PHAsset]() // Provide an initial empty array
    @State private var averageRating: Double = 10
    

    var body: some Scene {
        WindowGroup {
            NavigationView {
             ContentView()
            }
        }
    }
}
