//
//  TabBarAccessor.swift
//  TDD
//
//  Created by 최안용 on 8/18/24.
//

import SwiftUI
import UIKit

struct TabBarAccessor: UIViewControllerRepresentable {
    var callback: (UITabBar) -> Void
    
    private let proxyController = ProxyViewController()
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarAccessor>) -> UIViewController {
        proxyController.callback = callback
        return proxyController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<TabBarAccessor>) {
    }
    
    private class ProxyViewController: UIViewController {
        var callback: (UITabBar) -> Void = {_ in }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            if let tabBarController = self.tabBarController {
                callback(tabBarController.tabBar)
            }
        }
    }
}

extension View {
    func setTabBarVisibility(isHidden: Bool) -> some View {
        background(TabBarAccessor(callback: { tabBar in
            tabBar.isHidden = true
        }))
    }
}
