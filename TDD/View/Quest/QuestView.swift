//
//  QuestView.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import SwiftUI

struct QuestView: View {
    @StateObject var viewModel: QuestViewModel
    
    var body: some View {
        ScrollView {
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
        .scrollIndicators(.hidden)
        .toolbarBackground(.hidden, for: .tabBar)
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
                } action2: {
                    viewModel.send(id: user.userId)
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
        QuestView(viewModel: .init(users: [.stu1, .stu2, .stu3, .stu4],container: .stub))
    }
}
