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
            case .authenticated:
                MainTabView(viewModel: .init(container: container))
            }
        }
        .environmentObject(viewModel)
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static let container: DIContainer = .init(services: StubService())
    
    static var previews: some View {
        AuthenticationView(viewModel: AuthenticationViewModel(container: Self.container))
            .environmentObject(Self.container)
    }
}
