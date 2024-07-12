//
//  TDDApp.swift
//  TDD
//
//  Created by 최안용 on 7/9/24.
//

import SwiftUI

@main
struct TDDApp: App {
    @StateObject var container: DIContainer = .init(services: Services())
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView(viewModel: AuthenticationViewModel())
                .environmentObject(container)
        }
    }
}


class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("AppDelegate received URL: \(url)")
        NotificationCenter.default.post(name: Notification.Name("GitHubLogin"), object: url)
        print("Tlqkf received URL: \(url)")
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        print("SceneDelegate received URL: \(url)")
        NotificationCenter.default.post(name: Notification.Name("GitHubLogin"), object: url)
    }
}

