//
//  CreateRepoView.swift
//  TDD
//
//  Created by 최안용 on 7/17/24.
//

import SwiftUI

struct CreateRepoView: View {
    @StateObject var viewModel: CreateRepoViewModel
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name
        case description
    }
    
    var body: some View {
        GeometryReader {_ in
            ZStack {
                VStack(alignment: .leading) {
                    headerView
                    textFieldView
                    radioBtnView
                    createBtnView
                    Spacer()
                }
                
            }
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            focusedField = nil
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .alert(isPresented: $viewModel.isPresentAlert) {
            switch viewModel.alert {
            case .create:
                return Alert(title: Text("\(viewModel.name)"),
                             message: Text("Repository를 생성하시겠습니까?"),
                             primaryButton: .cancel(Text("취소"), action: {}),
                             secondaryButton: .default(Text("확인")) {
                    viewModel.createRepo()
                })
            case .inputError:
                return Alert(title: Text("입력 오류"),
                             dismissButton: .cancel(Text("확인"), action: {}))
            }
        }
        
    }
    
    private var headerView: some View {
        Text("새로운 저장소를 생성하세요")
            .font(.system(size: 28, weight: .bold))
            .foregroundStyle(Color.fixBk)
            .padding(.horizontal, 23)
            .padding(.vertical, 58)
    }
    
    private var textFieldView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 1) {
                Text("Repository Name")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(Color.fixBk)
                
                Text("*")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(Color.main)
            }
            .padding(.bottom, 4)
            
            TextField("텍스트 입력", text: $viewModel.name)
                .font(.system(size: 16, weight: .thin))
                .padding(.vertical, 11)
                .focused($focusedField, equals: .name)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .description
                }
            
            Rectangle().frame(height: 1)
                .foregroundStyle(.fixBk.opacity(0.1))
                .padding(.bottom, 28)
            
            Text("Description")
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(Color.fixBk)
                .padding(.bottom, 4)
            
            TextField("텍스트 입력", text: $viewModel.description)
                .font(.system(size: 16, weight: .thin))
                .padding(.vertical, 11)
                .focused($focusedField, equals: .description)
                .submitLabel(.done)
                .onSubmit {
                    focusedField = nil
                }
            
            Rectangle().frame(height: 1)
                .foregroundStyle(.fixBk.opacity(0.1))

        }
        .padding(.horizontal, 24)
    }
    
    private var radioBtnView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                Button(action: {
                    viewModel.isPrivate = false
                }, label: {
                    Image(viewModel.isPrivate ? "radioBtn" : "radioBtnClick")
                        .resizable()
                        .frame(width: 24, height: 24)
                })

                VStack(alignment: .leading, spacing: 2) {
                    Text("Public")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.fixBk)
                    Text("인터넷에 있는 모든 사람이 이 저장소를 볼 수 있습니다.")
                        .font(.system(size: 12, weight: .thin))
                        .foregroundStyle(Color.serve)
                }
            }
            .padding(.bottom, 14)
            
            HStack(spacing: 12) {
                Button(action: {
                    viewModel.isPrivate = true
                }, label: {
                    Image(viewModel.isPrivate ? "radioBtnClick" : "radioBtn")
                        .resizable()
                        .frame(width: 24, height: 24)
                })                
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Private")
                        .font(.headline)
                    Text("다른 사람들이 이 저장소를 볼 수 없습니다.")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding(.top, 39)
        .padding(.horizontal, 24)
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
                HStack(spacing: 0) {
                    Image(.icGitgub)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.fixWh)
                        .padding(.trailing, 16)
                    Text("Repository 생성")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.fixWh)
                    
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 82.5)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(!viewModel.name.isEmpty ? Color.fixBk : Color.serve)
                }
            })
            .disabled(viewModel.name.isEmpty)
            Spacer()
        }
        .padding(.top, 211)
    }
}

#Preview {
    CreateRepoView(viewModel: CreateRepoViewModel(mainTabViewModel: .init(container: .stub), container: .init(services: StubService())) )
}
