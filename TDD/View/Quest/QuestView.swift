//
//  QuestView.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import SwiftUI

struct QuestView: View {
    @EnvironmentObject private var container: DIContainer
    @StateObject var viewModel: QuestViewModel
    @State var isRefreshing: Bool = false
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.questDestinations) {
            RefreshableScrollView(isRefreshing: $isRefreshing) {
                refresh()
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
            .navigationDestination(for: NavigationDestination.self) {
                NavigationRoutingView(destination: $0)
            }
        }
    }
    private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isRefreshing = false
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
                .onTapGesture {
                    viewModel.clickedUserCell(user)
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
