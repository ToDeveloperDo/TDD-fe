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
        VStack {
            Spacer()
            Button(action: {
                viewModel.isPresent = true
            }, label: {
                HStack(spacing: 15) {
                    Image(.icGitgub)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 30, height: 30)
                        .tint(Color.reverseText)
                    
                    Text("GitHub 연동하기")
                        .font(.headline)
                        .foregroundStyle(Color.reverseText)
                }
            })
            .frame(maxWidth: .infinity, maxHeight: 50)            
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.text)
            }
            .frame(maxWidth: .infinity, maxHeight: 50)
            .padding(.horizontal, 30)
        }
        .sheet(isPresented: $viewModel.isPresent, content: {
            MyWebView(urlToLoad: viewModel.url).ignoresSafeArea()
        })
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    LinkGitHubView(viewModel: .init(container: .stub, mainTabViewModel: .init(container: .stub)))
}
