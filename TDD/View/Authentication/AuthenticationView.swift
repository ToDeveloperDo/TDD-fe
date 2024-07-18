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
                    .onAppear {
                        viewModel.check()
                    }
            case .authenticated:
                MainTabView(viewModel: .init(container: container))
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    AuthenticationView(viewModel: AuthenticationViewModel())
        .environmentObject(DIContainer(services: StubService()))
}
