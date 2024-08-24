//
//  SettingView.swift
//  TDD
//
//  Created by 최안용 on 8/18/24.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var viewModel: SettingViewModel
    
    var body: some View {
        ScrollView {
            Spacer()
                .frame(height: 88)
                .padding(.bottom, 48)
            
            SettingCellView(title: "개인정보 처리 방침") {
                
            }
            .padding(.bottom, 4)
            
            SettingCellView(title: "문의하기") {
                
            }
            .padding(.bottom, 4)
            
            SettingCellView(title: "팀 소개") {
                viewModel.push()
            }
            .padding(.bottom, 4)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.linegray)
            
            SettingCellView(title: "로그아웃") {
                
            }
            
            SettingCellView(title: "회원 탈퇴") {
                viewModel.revoke()
            }
            Spacer()
        }
        .ignoresSafeArea()
        
        .padding(.horizontal, 24)
 
        .background(Color.mainbg)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    viewModel.pop()
                } label: {
                    Image(.backBtn)
                }
                
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Text("설정")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(Color.fixBk)
            }
        }
        .toolbarColorScheme(.light, for: .navigationBar)
        .navigationBarBackButtonHidden()
    }
}

private struct SettingCellView: View {
    private let title: String
    private var action: () -> Void
    
    fileprivate init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .light))
                    .foregroundStyle(Color.fixBk)
                Spacer()
            }
            .padding(.top, 12)
            .padding(.bottom, 11)
        })
    }
}

#Preview {
    NavigationView {
        SettingView(viewModel: .init(container: .stub, authViewModel: .init(container: .stub)))
    }
}
