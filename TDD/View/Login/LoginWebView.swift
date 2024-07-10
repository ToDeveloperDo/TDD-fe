//
//  LoginWebView.swift
//  TDD
//
//  Created by 최안용 on 7/10/24.
//

import SwiftUI
import WebKit

struct LoginWebView: UIViewRepresentable {
    var urlToLoad: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: urlToLoad) else {
            return WKWebView()
        }
        
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}

#Preview {
    LoginWebView(urlToLoad: "https://www.naver.com")
}
