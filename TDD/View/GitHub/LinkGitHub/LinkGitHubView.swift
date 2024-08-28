//
//  LinkGitHubView.swift
//  TDD
//
//  Created by 최안용 on 7/30/24.
//

import SwiftUI

struct LinkGitHubView: View {
    @StateObject var viewModel: LinkGitHubViewModel
    
    var body: some View {
        ZStack {
            Image(.appLogo)
                .resizable()
                .frame(width: 64, height: 66)
            
            VStack {
                Spacer()
                Button(action: {
                    viewModel.isPresent = true
                }, label: {
                    HStack(spacing: 16) {
                        Image(.icGitgub)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 21, height: 20)
                            .tint(Color.fixWh)
                        
                        Text("GitHub 연동하기")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.fixWh)
                    }
                })
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.fixBk)
                }
                .padding(.horizontal, 47)
            }
        }
        .background(Color.mainbg)
        .sheet(isPresented: $viewModel.isPresent, content: {
            MyWebView(urlToLoad: viewModel.url).ignoresSafeArea()
        })
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    LinkGitHubView(viewModel: .init(container: .stub, mainTabViewModel: .init(container: .stub)))
}
