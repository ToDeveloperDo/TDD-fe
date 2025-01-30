//
//  CurriculumMakeView.swift
//  TDD
//
//  Created by 최안용 on 12/12/24.
//

import SwiftUI

struct CurriculumMakeView: View {
    @StateObject var viewModel: CurriculumMakeViewModel
    
    var body: some View {
        Group {
            switch viewModel.step {
            case .start: StartView(viewModel: viewModel)
            default: StepView(viewModel: viewModel)
            }
        }
        .background(Color.mainbg)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    viewModel.send(action: .backButtonTapped)
                } label: {
                    Image(.icWestArrow)
                }
                
            }
        }
        .toolbarColorScheme(.light, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .disabled(viewModel.isLoading)
        .overlay {
            if viewModel.isLoading {
                VStack {
                    ProgressView("커리큘럼 생성중...")
                        .foregroundStyle(.fixWh)
                        .font(.system(size: 18, weight: .bold))
                        .controlSize(.large)
                        .tint(.main)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 40)
                .background(Color.calendarDayGray.opacity(0.8))
                .cornerRadius(20, corners: .allCorners)
            }
        }
    }
}

private struct StartView: View {
    @ObservedObject private var viewModel: CurriculumMakeViewModel
    
    fileprivate init(viewModel: CurriculumMakeViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 0) {
            Image(.icLoading)
                .resizable()
                .frame(width: 108, height: 108)
                .padding(.bottom, 36)
            
            Text("어떤 목표를 이루고 싶으신가요?")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.fixBk)
                .padding(.bottom, 12)
            
            Text("간단한 몇 가지 질문에 답하고 나만의 맞춤 계획을 확인해보세요!")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.fixBk)
            
            Spacer()
            
            CurriculumButton(title: "시작하기") {
                viewModel.send(action: .nextButtonTapped)
            }
        }
        .padding(.horizontal, 23)
        .padding(.top, 137)
        .padding(.bottom, 124)
    }
}

private struct StepView: View {
    @ObservedObject private var viewModel: CurriculumMakeViewModel
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible())]
    
    fileprivate init(viewModel: CurriculumMakeViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 0) {
            Text(viewModel.step.title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.fixBk)
                .padding(.bottom, 75)
            
            Text(viewModel.step.rawValue)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.sectionTitleGray)
                .padding(.bottom, 25)
            
            Rectangle().frame(height: 1)
                .foregroundStyle(.black50)
            
            LazyVGrid(columns: columns) {
                ForEach(viewModel.step.kinds(position: viewModel.selectedKind[.position]), id: \.self) { kind in
                    SectionButton(
                        title: kind,
                        isSelected: viewModel.isSelectedKind(kind: kind)
                    ) {
                        viewModel.send(action: .clickedKind(kind: kind))
                    }
                }
            }
            .padding(.top, 8)
            
            Spacer()
            
            CurriculumButton(title: viewModel.step.buttonTitle) {
                viewModel.send(action: .nextButtonTapped)
            }
            .disabled(!viewModel.isButtonValid())
        }
        .padding(.top, 72)
        .padding(.bottom, 124)
        .padding(.horizontal, 23)
    }
}

#Preview {
    NavigationView {
        CurriculumMakeView(viewModel: .init(container: .stub))
    }
}
