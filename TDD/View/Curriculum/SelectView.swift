//
//  SelectView.swift
//  TDD
//
//  Created by 최안용 on 11/12/24.
//

import SwiftUI
    
struct SelectView: View {
    @ObservedObject private var viewModel: CurriculumViewModel
    
    init(viewModel: CurriculumViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HeaderView()
                .padding(.top, 36)
            ForEach(SectionInfo.allCases, id: \.self) { item in
                VStack(spacing: 8) {
                    SectionTitle(
                        section: item,
                        isSelected: isSelectedTitle(item),
                        selectedItem: selectedItem(for: item)
                    )
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 8) {
                        ForEach(item.kinds(for: viewModel.selectedPosition), id: \.self) { kind in
                            SectionButton(title: kind, isSelected: isSelected(item, kind: kind)) {
                                viewModel.updateSelection(for: item, with: kind)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 36)
            .padding(.horizontal, 24)
            CreateButtonView(viewModel: viewModel)
        }
    }
    
    private func isSelectedTitle(_ item: SectionInfo) -> Bool {
        switch item {
        case .position:
            return !viewModel.selectedPosition.rawValue.isEmpty
        case .stack:
            return !viewModel.selectedStack.isEmpty
        case .period:
            return !viewModel.selectedPeriod.isEmpty
        case .level:
            return !viewModel.selectedLevel.isEmpty
        }
    }
    
    private func isSelected(_ item: SectionInfo, kind: String? = nil) -> Bool {
            switch item {
            case .position:
                return viewModel.selectedPosition.rawValue == kind
            case .stack:
                return viewModel.selectedStack == kind
            case .period:
                return viewModel.selectedPeriod == kind
            case .level:
                return viewModel.selectedLevel == kind
            }
        }

        private func selectedItem(for item: SectionInfo) -> String {
            switch item {
            case .position:
                return viewModel.selectedPosition.rawValue
            case .stack:
                return viewModel.selectedStack
            case .period:
                return viewModel.selectedPeriod
            case .level:
                return viewModel.selectedLevel
            }
        }

}

private struct HeaderView: View {
    fileprivate var body: some View {
        Text("목표를 생성해드립니다!")
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(.fixBk)
            .padding(.horizontal, 24)
    }
}

private struct CreateButtonView: View {
    @ObservedObject private var viewModel: CurriculumViewModel
    
    fileprivate init(viewModel: CurriculumViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        Button(action: {
            viewModel.tappedButton()
        }) {
            HStack {
                Spacer()
                Text("생성하기")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(viewModel.buttonValiadation() ? .fixBk : .fixWh)
                    .padding(.vertical, 20)
                Spacer()
            }
            .background(viewModel.buttonValiadation() ? .serve2 : .main)
            .cornerRadius(10, corners: .allCorners)
            .padding(.horizontal, 24)
        }
        .disabled(viewModel.buttonValiadation())
        .padding(.top, 36)
        .padding(.bottom, 60)
    }
}


#Preview {
    SelectView(viewModel: .init(container: .stub))
}
