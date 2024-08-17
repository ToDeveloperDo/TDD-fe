//
//  RefreshableScrollView.swift
//  TDD
//
//  Created by 최안용 on 8/16/24.
//

import SwiftUI

struct RefreshableScrollView<Content: View>: UIViewRepresentable {
    private var content: Content
    @Binding var isRefreshing: Bool
    let onRefresh: () -> Void
    
    init(isRefreshing: Binding<Bool>, onRefresh: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self._isRefreshing = isRefreshing
        self.onRefresh = onRefresh
        self.content = content()
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        
        // UIRefreshControl 설정
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.handleRefreshControl), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        // UIHostingController 설정
        let hostingController = context.coordinator.hostingController
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // hostingController의 뷰를 scrollView에 추가
        scrollView.addSubview(hostingController.view)
        
        // 레이아웃 제약 설정
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // 스크롤 뷰 설정
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = UIColor(named: "mainbg")
        
        return scrollView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // RefreshControl 상태 업데이트
        if isRefreshing {
            uiView.refreshControl?.beginRefreshing()
        } else {
            uiView.refreshControl?.endRefreshing()
        }
        
        // hostingController의 콘텐츠 업데이트
        context.coordinator.hostingController.rootView = content
        
        // 레이아웃 제약 조건 업데이트
        context.coordinator.hostingController.view.setNeedsUpdateConstraints()
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        let parent: RefreshableScrollView
        var hostingController: UIHostingController<Content>
        
        init(parent: RefreshableScrollView) {
            self.parent = parent
            self.hostingController = UIHostingController(rootView: parent.content)
        }
        
        @objc func handleRefreshControl(sender: UIRefreshControl) {
            if !parent.isRefreshing {
                parent.isRefreshing = true
                parent.onRefresh()
            }
        }
    }
}
