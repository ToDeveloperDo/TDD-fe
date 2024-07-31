//
//  LoginView.swift
//  TDD
//
//  Created by 최안용 on 7/10/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            Spacer()
            
            SignInWithAppleButton { request in
                viewModel.send(action: .appleLogin(request))
            } onCompletion: { completion in
                viewModel.send(action: .appleLoginCompletion(completion))
            }
            .frame(maxWidth: .infinity, maxHeight: 50)
            .padding(.horizontal, 30)
            .signInWithAppleButtonStyle(.black)

        }    
    }
}

struct LoginView_Previews: PreviewProvider {
    static let viewModel = AuthenticationViewModel(container: .stub)

    static var previews: some View {
        LoginView()
            .environmentObject(viewModel)
    }
}
