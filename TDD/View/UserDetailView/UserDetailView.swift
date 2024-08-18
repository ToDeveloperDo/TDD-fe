//
//  UserDetailView.swift
//  TDD
//
//  Created by 최안용 on 8/17/24.
//

import SwiftUI

struct UserDetailView: View {
    @EnvironmentObject private var container: DIContainer
    @ObservedObject var viewModel: UserDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                userInfoCell
                    .padding(.bottom, 36)
            
                if viewModel.user.status == .FOLLOWING {
                    if viewModel.userTodoList.isEmpty {
                        EmptyView()
                            .padding(.top, 24)
                    } else {
                        FriendTodoListView(friendTodoList: viewModel.userTodoList)
                    }
                } else {
                    HiddenView()
                        .padding(.top, 24)
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar(.hidden, for: .tabBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.fixWh, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 0) {
                        ToolbarBtn(infoType: viewModel.user.status) {
                            
                        }
                    }.padding(.horizontal, 8)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        viewModel.send(action: .pop)
                    }, label: {
                        Image(.backBtn)
                    })
                }
            }
        }
        .scrollDisabled(!(viewModel.user.status == .FOLLOWING))
        .background(Color.mainbg)
    }
    
    private var userInfoCell: some View {
        VStack(alignment: .leading, spacing: 0) {
            UserInfoView(url: viewModel.user.profileUrl)
                .padding(.top, 120)
                .background(Color.fixWh)
                .padding(.bottom, 28)
            Text("\(viewModel.user.userName)")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(Color.text)
                .padding(.bottom, 8)
                .padding(.horizontal, 24)
            Button(action: {
                
            }, label: {
                Text("\(viewModel.user.gitUrl)")
                    .font(.system(size: 14, weight: .light))
                    .tint(Color.text)
            })
            .padding(.horizontal, 24)
        }
    }
}

private struct HiddenView: View {
    var body: some View {
        VStack {
            
            Image(.hiddenTodo)
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
                .font(.system(size: 12, weight: .light))
                .foregroundStyle(Color.fixBk)
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        UserDetailView(viewModel: .init(user: .stu3, container: .stub))
    }
}
