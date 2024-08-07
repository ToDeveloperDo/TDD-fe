//
//  CreateRepoView.swift
//  TDD
//
//  Created by 최안용 on 7/17/24.
//

import SwiftUI

struct CreateRepoView: View {
    @StateObject var viewModel: CreateRepoViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                headerView
                Rectangle().frame(height: 1)
                textFieldView
                radioBtnView
                createBtnView
                Spacer()
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .navigationBarBackButtonHidden()
        .alert(isPresented: $viewModel.isPresentAlert) {
            switch viewModel.alert {
            case .create:
                return Alert(title: Text("\(viewModel.name)"),
                             message: Text("Repository를 생성하시겠습니까?"),
                             primaryButton: .cancel(Text("취소"), action: {}),
                             secondaryButton: .default(Text("확인")) {
                    viewModel.createRepo()
                    //TODO: - 레포 생성 API 호출
                })
            case .inputError:
                return Alert(title: Text("입력 오류"),
                             message: Text("Repository Name을 입력해야 합니다."),
                             dismissButton: .cancel(Text("확이"), action: {}))
            }
        }
       
    }
    
    private var headerView: some View {
        Text("새로운 저장소를 생성하세요")
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(Color.text)
            .padding(.horizontal, 20)
    }
    
    private var textFieldView: some View {
        VStack(alignment: .leading) {
            Text("필수 항목은 별표(*)로 표시되어 있습니다.")
                .font(.caption)
                .foregroundStyle(Color.gray)
            
            HStack(spacing: 1) {
                Text("Repository Name")
                    .font(.headline)
                    .foregroundStyle(Color.text)
                
                Text("*")
                    .font(.headline)
                    .foregroundStyle(Color.red)
            }
            .padding(.top, 25)
            TextField("", text: $viewModel.name)
                .textFieldStyle(.roundedBorder)
            
            HStack {
                Text("Description")
                    .font(.headline)
                    .foregroundStyle(Color.text)
                
                Text("(선택사항)")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }
            .padding(.top, 10)
            
            TextField("", text: $viewModel.description)
                .textFieldStyle(.roundedBorder)
            
        }
        .padding(.horizontal, 20)
    }
    
    private var radioBtnView: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Circle()
                    .stroke()
                    .foregroundStyle(Color.text)
                    .frame(width: 23)
                    .overlay {
                        if !viewModel.isPrivate {
                            Circle()
                                .stroke(lineWidth: 5)
                                .foregroundStyle(Color.blue)
                                .frame(width: 19)
                        }
                    }
                
                Image(.icGitRepo)
                    .renderingMode(.template)
                    .foregroundStyle(Color.text)
                
                VStack(alignment: .leading) {
                    Text("Public")
                        .font(.headline)
                    Text("인터넷에 있는 모든 사람이 이 저장소를 볼 수 있습니다.")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            .onTapGesture {
                viewModel.isPrivate = false
            }
            
            HStack {
                Circle()
                    .stroke()
                    .foregroundStyle(Color.text)
                    .frame(width: 23)
                    .overlay {
                        if viewModel.isPrivate {
                            Circle()
                                .stroke(lineWidth: 5)
                                .foregroundStyle(Color.blue)
                                .frame(width: 19)
                        }
                    }
                
                Image(.icGitRock)
                    .renderingMode(.template)
                    .foregroundStyle(Color.text)
                
                VStack(alignment: .leading) {
                    Text("Private")
                        .font(.headline)
                    Text("다른 사람들이 이 저장소를 볼 수 없습니다.")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            .onTapGesture {
                viewModel.isPrivate = true
            }  
        }
        .padding(.top, 25)
        .padding(.horizontal, 20)
    }
    
    private var createBtnView: some View {
        HStack {
            Spacer()
            Button(action: {
                viewModel.isPresentAlert = true
                if viewModel.name == "" {
                    viewModel.alert = .inputError
                } else {
                    viewModel.alert = .create
                }
            }, label: {
                Label(
                    title: { 
                        Text("Repository 생성")
                            .font(.body)
                            .foregroundStyle(Color.reverseText)
                    },icon: {
                        Image(.icGitgub)
                            .renderingMode(.template)
                            .foregroundStyle(Color.reverseText)
                    }
                )
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
                .background {
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundStyle(Color.text)
                }
            })
            Spacer()
        }
        .padding(.top, 40)
    }
}

#Preview {
    CreateRepoView(viewModel: CreateRepoViewModel(mainTabViewModel: .init(container: .stub), container: .init(services: StubService())) )
}
