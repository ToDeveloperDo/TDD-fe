//
//  LoginView.swift
//  TDD
//
//  Created by 최안용 on 7/10/24.
//

import SwiftUI

struct LoginView: View {
    @State var isPresent: Bool = false
    @State private var authToken: String? = nil
    
    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
                isPresent.toggle()
            }, label: {
                HStack {
                    Image("ic_gitgub")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                    
                    Text("GitHub로 시작하기")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 25)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.black)
                }
            })
        }
        .sheet(isPresented: $isPresent) {
            LoginWebView(urlToLoad: URL(string: "https://api.todeveloperdo.shop/git/login")!)
                .ignoresSafeArea()
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: Notification.Name("GitHubLogin"), object: nil, queue: .main) { notification in
                if let url = notification.object as? URL {
                    if let token = extractToken(from: url) {
                        self.authToken = token
                        self.isPresent = false
                        print("Received JWT token: \(token)")
                    }
                }
            }
        }
    }
    
    private func extractToken(from url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        return components?.queryItems?.first(where: { $0.name == "token"})?.value
    }
}

#Preview {
    LoginView()
}
