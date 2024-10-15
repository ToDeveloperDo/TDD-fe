//
//  AuthenticationView.swift
//  TDD
//
//  Created by 최안용 on 7/10/24.
//

import SwiftUI

struct AuthenticationView: View {
    @State var isLaunch: Bool = true
    @StateObject var viewModel: AuthenticationViewModel
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        ZStack {
            Group {
                switch viewModel.authState {
                case .unAuthenticated:
                    LoginView()
                        .alert("로그인 오류", isPresented: $viewModel.isPresent, actions: {
                            Button("확인", role: .cancel) {  }
                        }, message: {
                            Text("다시 시도해주세요!")
                        })                                           
                case .authenticated:
                    MainTabView(viewModel: .init(container: container))
                }
            }.zIndex(0)
            
            if isLaunch {
                SplashView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .environmentObject(viewModel)
        .onAppear {
            viewModel.send(action: .checkLoginState)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                withAnimation { isLaunch.toggle() }
                viewModel.send(action: .updateFcmToken)
            })
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static let container: DIContainer = .init(services: StubService())
    
    static var previews: some View {
        AuthenticationView(viewModel: AuthenticationViewModel(container: Self.container))
            .environmentObject(Self.container)
    }
}
