//
//  TestGroundApp.swift
//  TestGround
//
//  Created by User on 20/07/2024.
//
import SwiftUI
import GooglePlaces

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    GMSPlacesClient.provideAPIKey("AIzaSyDZdzqDwtaIe2lesCU9vX74tpDgixpqzyY")
    return true
  }
}

import SwiftUI

@main
struct TestGroundApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var isExpanded = false
        
        var body: some Scene {
            WindowGroup {
                GalleryView()
            }
        }
    }
