//
//  LoginWebView.swift
//  TDD
//
//  Created by 최안용 on 7/10/24.
//

import SwiftUI
import SafariServices

struct LoginWebView: UIViewControllerRepresentable {
    let urlToLoad: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<LoginWebView>) -> SFSafariViewController {
        return SFSafariViewController(url: urlToLoad)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

