//
//  CurriculumView.swift
//  TDD
//
//  Created by 최안용 on 11/10/24.
//

import SwiftUI

struct CurriculumView: View {
    @StateObject var viewModel: CurriculumViewModel
    
    var body: some View {
        ScrollView {
            switch viewModel.phase {
            case .notRequest:
                SelectView(viewModel: viewModel)
            case .success:
                CurriculumLoadedView(viewModel: viewModel)
            }
        }
        .disabled(viewModel.isLoading || viewModel.isError)
        .overlay {
            if viewModel.isError {
                NetworkErrorAlert(title: "네트워크 통신 에러")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                            withAnimation {
                                viewModel.isError = false
                            }
                        }
                    }
            }
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


struct CurriculumView_Previews: PreviewProvider {
    static let container: DIContainer = .init(services: StubService())
    
    static var previews: some View {
        CurriculumView(viewModel: CurriculumViewModel(container: Self.container))
            .environmentObject(Self.container)
    }
}
