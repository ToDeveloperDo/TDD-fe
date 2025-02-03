//
//  CurriculumLoadedView.swift
//  TDD
//
//  Created by 최안용 on 11/12/24.
//

import SwiftUI

struct LoadedCurriculumView: View {
    @ObservedObject private var viewModel: LoadedCurriculumViewModel
    
    init(viewModel: LoadedCurriculumViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            PeriodView(viewModel: viewModel)
            if !viewModel.curriculums.isEmpty {
                HeaderView(viewModel: viewModel)
                ContentsView(viewModel: viewModel)
                AddButtonView(viewModel: viewModel)
            }
        }
        .background(.fixWh)
        .disabled(viewModel.isLoading)
        .overlay {
            if viewModel.isLoading {
                VStack {
                    ProgressView("커리큘럼 저장중...")
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
        .onAppear {
            viewModel.send(action: .fetchCurriculum)
        }
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
    }
}

private struct PeriodView: View {
    @ObservedObject private var viewModel: LoadedCurriculumViewModel
    
    fileprivate init(viewModel: LoadedCurriculumViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(0..<viewModel.curriculums.count, id: \.self) { index in
                    Button {
                        viewModel.send(action: .tappedWeek(week: index))
                    } label: {
                        Text("\(index+1)주차")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(viewModel.selectedWeek == index ? .fixWh : .fixBk)
                            .padding(.horizontal, 22)
                            .padding(.vertical, 9.5)
                    }
                    .background(viewModel.selectedWeek == index ? .primary100 : .fixWh)
                    .cornerRadius(10, corners: .allCorners)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(viewModel.selectedWeek == index ? .clear : .primary50)
                    }
                }
            }
            .padding(.bottom, 1)
            .padding(.horizontal, 24)
            .padding(.top, 28)
        }
    }
}

private struct HeaderView: View {
    @ObservedObject private var viewModel: LoadedCurriculumViewModel
    
    fileprivate init(viewModel: LoadedCurriculumViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            Spacer()
            Text("\(viewModel.curriculums[viewModel.selectedWeek].object)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.fixBk)
            Spacer()
        }
        .padding(.top, 56)
        .padding(.horizontal, 24)
    }
}

private struct ContentsView: View {
    @ObservedObject private var viewModel: LoadedCurriculumViewModel
    
    fileprivate init(viewModel: LoadedCurriculumViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.curriculums[viewModel.selectedWeek].contents) { content in
                ContentButton(subject: content) {
                    viewModel.send(action: .tappedCurriculum(curriculum: content))
                }
                .disabled(viewModel.curriculums[viewModel.selectedWeek].isRegistration)
            }
            
            
        }
        .padding(.bottom, 1)
        .padding(.top, 48)
    }
}

private struct ContentButton: View {
    var subject: DetailSubject
    var action: () -> Void
    
    fileprivate init(subject: DetailSubject, action: @escaping () -> Void) {
        self.subject = subject
        self.action = action
    }
    
    fileprivate var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text("\(subject.title)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.fixBk)
                Spacer()
                Image(subject.isSelected ? .contentSelectedCheckBox : .contentCheckBox)
            }
            .padding(.leading, 22)
            .padding(.trailing, 11)
            .padding(.vertical, 11)
            .background(subject.isSelected ? .primary50 : .fixWh)
            .cornerRadius(10, corners: .allCorners)
            .overlay {
                if !subject.isSelected {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.primary50)
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

private struct AddButtonView: View {
    @ObservedObject private var viewModel: LoadedCurriculumViewModel
    
    fileprivate init(viewModel: LoadedCurriculumViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        Button(action: {
            viewModel.send(action: .tappedRegistration)
        }) {
            HStack {
                Spacer()
                Text("등록하기")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.fixWh)
                    .padding(.vertical, 20)
                Spacer()
            }
            .background(viewModel.addButtonValidation() ? .black50 : .primary100)
            .cornerRadius(10, corners: .allCorners)
            .padding(.horizontal, 24)
        }
        .disabled(viewModel.addButtonValidation())
        .padding(.top, 74)
        .padding(.bottom, 60)
    }
}

#Preview {
    LoadedCurriculumView(viewModel: .init(container: .stub, selectedStep: [:]))
}
