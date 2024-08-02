//
//  AuthenticationView.swift
//  TDD
//
//  Created by 최안용 on 7/10/24.
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject var viewModel: AuthenticationViewModel
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        Group {
            switch viewModel.authState {
            case .unAuthenticated:
                LoginView()
                    .alert("로그인 오류", isPresented: $viewModel.isPresent) {
                         Button("OK", role: .cancel) {  }
                       }
                    .environmentObject(viewModel)
            case .authenticated:
                MainTabView(viewModel: .init(container: container))
            }
        }
        .onAppear {
            viewModel.send(action: .checkLoginState)
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
