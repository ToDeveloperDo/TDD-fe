//
//  UserDetailView.swift
//  TDD
//
//  Created by 최안용 on 8/17/24.
//

import SwiftUI

struct UserDetailView: View {
    @ObservedObject var viewModel: UserDetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    userInfoCell
                        .padding(.bottom, 36)
                    
                    if viewModel.user.status == .FOLLOWING {
                        if viewModel.isLoading {
                            LoadingView()
                        } else {
                            if viewModel.userTodoList.isEmpty {
                                EmptyView()
                                    .padding(.top, 100)
                            } else {
                                FriendTodoListView(friendTodoList: viewModel.userTodoList)
                            }
                        }
                    } else {
                        HiddenView()
                            .padding(.top, 24)
                    }
                }
            }
            .background(Color.mainbg)
            .scrollDisabled(!(viewModel.user.status == .FOLLOWING))
        }
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    viewModel.send(action: .pop)
                }, label: {
                    Image(.backBtn)
                })
                
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                ToolbarBtn(infoType: viewModel.user.status) {
                    viewModel.send(action: .infoTypeBtnClicked)
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $viewModel.isPresentGit) {
            MyWebView(urlToLoad: URL(string: viewModel.user.gitUrl)!)
                .ignoresSafeArea()
        }
    }
    
    private var userInfoCell: some View {
        VStack(alignment: .leading, spacing: 0) {
            UserInfoView(url: viewModel.user.profileUrl)
                .padding(.bottom, 28)
            Text("\(viewModel.user.userName)")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(Color.fixBk)
                .padding(.bottom, 8)
                .padding(.horizontal, 24)
            Button(action: {
                viewModel.isPresentGit = true
            }, label: {
                Text("\(viewModel.user.gitUrl)")
                    .font(.system(size: 14, weight: .thin))
                    .tint(Color.fixBk)
            })
            .padding(.horizontal, 24)
        }
    }
}

private struct HiddenView: View {
    var body: some View {
        VStack {
            Image(.hiddenTodo)
                .resizable()                
        }
    }
}

private struct EmptyView: View {
    var body: some View {
        VStack {
            Image(.icCalendarBack)
            Text("작성된 일정이 없어요")
                .font(.system(size: 16, weight: .light))
                .foregroundStyle(Color.serve)
        }
    }
}

private struct FriendTodoListView: View {
    private var friendTodoList: [FriendTodoList]
    
    fileprivate init(friendTodoList: [FriendTodoList]) {
        self.friendTodoList = friendTodoList
    }
    
    fileprivate var body: some View {
        ForEach(friendTodoList) { todoList in
            FriendTodoGroupView(todoList: todoList)
                .padding(.bottom, 6)
        }
    }
}

private struct FriendTodoGroupView: View {
    private var todoList: FriendTodoList
    
    fileprivate init(todoList: FriendTodoList) {
        self.todoList = todoList
    }
    
    fileprivate var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(todoList.title)")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.fixBk)
                .padding(.bottom, 13)
            ForEach(todoList.todos) { todo in
                FriendTodoCellView(todo: todo)
                    .padding(.bottom, 4)
            }
        }
        .padding(.horizontal, 13)
        .padding(.top, 12)
        .padding(.bottom, 11)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.fixWh)
        }
        .padding(.horizontal, 24)
    }
}

private struct FriendTodoCellView: View {
    private var todo: Todo
    
    fileprivate init(todo: Todo) {
        self.todo = todo
    }
    
    fileprivate var body: some View {
        HStack(spacing: 8) {
            Image(todo.status == .DONE ? .icSelectedBox : .icUnSelectedBox)
                .resizable()
                .frame(width: 18, height: 18)
            
            Text("\(todo.content)")
                .font(.system(size: 12, weight: .thin))
                .foregroundStyle(Color.fixBk)
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        UserDetailView(viewModel: .init(user: .stu3, parent: .quest, container: .stub))
    }
}
