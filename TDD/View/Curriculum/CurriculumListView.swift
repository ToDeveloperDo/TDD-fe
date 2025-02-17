//
//  CurriculumListView.swift
//  TDD
//
//  Created by 최안용 on 12/11/24.
//

import SwiftUI

struct CurriculumListView: View {
    @StateObject var viewModel: CurriculumListViewModel
    
    var body: some View {
        NavigationStack(path: $viewModel.container.navigationRouter.curriculumDestinations) {
            Group {
                if viewModel.curriculumList.isEmpty {
                    CurriculumEmptyView(viewModel: viewModel)
                } else {
                    CurriculumView(viewModel: viewModel)
                }
            }
            .navigationDestination(for: NavigationDestination.self) {
                NavigationRoutingView(destination: $0)
            }
        }
        .onAppear {
            viewModel.send(action: .fetchCurriculumList)
        }
        .onChange(of: viewModel.container.navigationRouter.curriculumDestinations) { oldValue, newValue in
            if newValue.isEmpty {
                viewModel.send(action: .fetchCurriculumList)
            }
        }
    }
}


private struct TitleView: View {
    fileprivate var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("나의 목표, 얼마나 달성하셨나요?")
                .font(.system(size: 20, weight: .bold))
            Text("생성한 목표를 다시 확인하고, 새롭게 목표를 추가할 수 있어요")
                .font(.system(size: 12, weight: .regular))
        }
        .foregroundStyle(.fixBk)
        .padding(.top, 34)
    }
}

private struct CurriculumEmptyView: View {
    @ObservedObject private var viewModel: CurriculumListViewModel
    
    fileprivate init(viewModel: CurriculumListViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TitleView()
            
            Spacer()
            
            HStack {
                Spacer()
                Text("아직 생성된 목표가 없습니다.")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.serve)
                Spacer()
                
            }
            Spacer()
            CurriculumButton(title: "새로운 커리큘럼 생성") {
                viewModel.send(action: .tappedCreateButton)
            }
        }
        .padding(.bottom, 124)
        .padding(.horizontal, 24)
    }
}

private struct CurriculumView: View {
    @ObservedObject private var viewModel: CurriculumListViewModel
    
    fileprivate init(viewModel: CurriculumListViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                TitleView()
                    .padding(.horizontal, 24)
                    
                VStack(spacing: 12) {
                    ForEach(viewModel.curriculumList, id: \.self) { curriculum in
                        CurriculumCell(curriculum: curriculum)
                            .onTapGesture {
                                viewModel.send(action: .tappedCurriculumCell(plan: curriculum))
                            }
                    }
                }
                .padding(.top, 48)
                
                CurriculumButton(title: "새로운 커리큘럼 생성") {
                    viewModel.send(action: .tappedCreateButton)
                }
                .padding(.horizontal, 24)
                .padding(.top, 198)
                .padding(.bottom, 124)
            }
        }
    }
}

private struct CurriculumCell: View {
    private var curriculum: Plan
    
    fileprivate init(curriculum: Plan) {
        self.curriculum = curriculum
    }
    
    fileprivate var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(curriculum.createDt)
                    .font(.system(size: 10, weight: .light))
                Text("\(curriculum.position), \(curriculum.stack), \(curriculum.targetPeriod)개월, \(curriculum.experienceLevel)")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundStyle(.fixBk)
            Spacer()
            
            Image(.icRightArrow)
        }
        .padding(.horizontal, 9)
        .padding(.top, 12)
        .padding(.bottom, 13)
        .background(Color.primary10)
        .cornerRadius(4, corners: .allCorners)
        .padding(.horizontal, 24)
    }
}

#Preview {
    CurriculumListView(viewModel: .init(container: .stub))
}
