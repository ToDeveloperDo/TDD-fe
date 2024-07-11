//
//  AuthenticationView.swift
//  TDD
//
//  Created by 최안용 on 7/10/24.
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject var authVM: AuthenticationViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    AuthenticationView(authVM: AuthenticationViewModel())
}
