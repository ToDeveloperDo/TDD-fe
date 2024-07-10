//
//  LoginView.swift
//  TDD
//
//  Created by 최안용 on 7/10/24.
//

import SwiftUI

struct LoginView: View {
    @State var ispresent: Bool = false
    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
                ispresent.toggle()
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
        .sheet(isPresented: $ispresent, content: {
            LoginWebView(urlToLoad: "https://api.todeveloperdo.shop/git/login")
        })
    }
}

#Preview {
    LoginView()
}
