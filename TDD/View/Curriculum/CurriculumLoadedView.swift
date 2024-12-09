//
//  CurriculumLoadedView.swift
//  TDD
//
//  Created by 최안용 on 11/12/24.
//

import SwiftUI

struct CurriculumLoadedView: View {
    @ObservedObject private var viewModel: CurriculumViewModel
    
    init(viewModel: CurriculumViewModel) {
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
    }
}

private struct PeriodView: View {
    @ObservedObject private var viewModel: CurriculumViewModel
    
    fileprivate init(viewModel: CurriculumViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(0..<viewModel.curriculums.count, id: \.self) { index in
                    Button {
                        viewModel.selectedWeek = index
                    } label: {
                        Text("\(index+1)주차")
                            .font(.system(size: 12, weight: .thin))
                            .foregroundStyle(viewModel.selectedWeek == index ? .fixWh : .main)
                            .padding(.horizontal, 22)
                            .padding(.vertical, 9.5)
                    }
                    .background(viewModel.selectedWeek == index ? .main : .fixWh)
                    .cornerRadius(10, corners: .allCorners)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(viewModel.selectedWeek == index ? .clear : .sectionBorder)
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
    @ObservedObject private var viewModel: CurriculumViewModel
    
    fileprivate init(viewModel: CurriculumViewModel) {
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
    @ObservedObject private var viewModel: CurriculumViewModel
    
    fileprivate init(viewModel: CurriculumViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.curriculums[viewModel.selectedWeek].contents) { content in
                ContentButton(subject: content) {
                    viewModel.tappedSubject(subject: content)
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
                    .font(.system(size: 12, weight: .thin))
                    .foregroundStyle(subject.isSelected ? .fixWh : .black)
                Spacer()
                Image(subject.isSelected ? .contentSelectedCheckBox : .contentCheckBox)
            }
            .padding(.leading, 22)
            .padding(.trailing, 11)
            .padding(.vertical, 11)
            .background(subject.isSelected ? .main : .fixWh)
            .cornerRadius(10, corners: .allCorners)
            .overlay {
                if !subject.isSelected {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.sectionBorder)
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

private struct AddButtonView: View {
    @ObservedObject private var viewModel: CurriculumViewModel
    
    fileprivate init(viewModel: CurriculumViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        Button(action: {
            viewModel.addButtonTapped()
            viewModel.curriculums[viewModel.selectedWeek].isRegistration = true
        }) {
            HStack {
                Spacer()
                Text("등록하기")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(viewModel.addButtonValidation() ? .fixBk : .fixWh)
                    .padding(.vertical, 20)
                Spacer()
            }
            .background(viewModel.addButtonValidation() ? .serve2 : .main)
            .cornerRadius(10, corners: .allCorners)
            .padding(.horizontal, 24)
        }
        .disabled(viewModel.addButtonValidation())
        .padding(.top, 74)
        .padding(.bottom, 60)
    }
}

#Preview {
    CurriculumLoadedView(viewModel: .init(container: .stub))
}
