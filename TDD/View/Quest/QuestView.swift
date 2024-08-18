//
//  QuestView.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import SwiftUI

struct QuestView: View {
    @StateObject var viewModel: QuestViewModel
    @State var isRefreshing: Bool = false
    var body: some View {
        RefreshableScrollView(isRefreshing: $isRefreshing) {
            isRefreshing = false
        } content: {
            VStack(spacing: 0) {
                SearchBar(text: $viewModel.searchName) {
                    
                }
                .padding(.top, 28)
                .padding(.horizontal, 24)
                
                if viewModel.users.isEmpty {
                    EmptyView()
                } else {
                    MemberCardView(viewModel: viewModel)
                    
                }
            }
            .background(Color.mainbg)
        }
        .background(Color.mainbg)
        .onAppear {
            viewModel.fetchMembers()
        }
    }
}

private struct MemberCardView: View {
    @ObservedObject private var viewModel: QuestViewModel
    private let columns = Array(repeating: GridItem(.fixed(170)), count: 2)
    
    fileprivate init(viewModel: QuestViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        LazyVGrid(columns: columns, content: {
            ForEach(viewModel.users) { user in
                UserInfoCardView(user: user) {
                    viewModel.accept(id: user.userId)
                }
            }
        })
        .padding(.top, 34)
    }
}

private struct EmptyView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("없음")
            Spacer()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        QuestView(viewModel: .init(users: [.stu1, .stu2],container: .stub))
    }
}
