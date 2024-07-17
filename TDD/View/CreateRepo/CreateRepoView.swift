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
        VStack(alignment: .leading) {
            headerView
            Rectangle().frame(height: 1)
            textFieldView
            radioBtnView
            Spacer()
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
                Button(action: {
                    
                }, label: {
                    Circle()
                        .stroke()
                        .foregroundStyle(Color.fixBk)
                        .frame(width: 23)
                })
                
                Image(.icGitRepo)
                
                VStack(alignment: .leading) {
                    Text("Public")
                        .font(.headline)
                    Text("인터넷에 있는 모든 사람이 이 저장소를 볼 수 있습니다.")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            
            HStack {
                Button(action: {
                    
                }, label: {
                    Circle()
                        .stroke()
                        .foregroundStyle(Color.fixBk)
                        .frame(width: 23)
                })
                
                Image(.icGitRock)
                
                VStack(alignment: .leading) {
                    Text("Private")
                        .font(.headline)
                    Text("다른 사람들이 볼 수 없습니다.")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding(.top, 25)
        .padding(.horizontal, 20)
    }
}

#Preview {
    CreateRepoView(viewModel: .init())
}
