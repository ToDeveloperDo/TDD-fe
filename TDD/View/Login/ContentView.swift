//
//  ContentView.swift
//  TDD
//
//  Created by 최안용 on 7/9/24.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    @State private var showWebView = false
    @State private var code: String? = nil
    @State private var userInfo: String = "User info will be displayed here."

    var body: some View {
        VStack {
            Button(action: {
                self.showWebView = true
            }) {
                Text("Login with GitHub")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Text(userInfo)
                .padding()

        }
        .sheet(isPresented: $showWebView, onDismiss: {
            if let code = self.code {
                fetchUserInfo(with: code)
            }
        }) {
            
                LoginWebView(urlToLoad: "https://api.todeveloperdo.shop/git/login")
            
        }
        
    }

    func fetchUserInfo(with code: String) {
        guard let url = URL(string: "https://api.todeveloperdo.shop/login/oauth2/code/github?code=\(code)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let userInfo = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.userInfo = userInfo
                }
            }
        }
        task.resume()
    }
}


#Preview {
    ContentView()
}
