//
//  RefreshableScrollView.swift
//  TDD
//
//  Created by 최안용 on 8/16/24.
//

import SwiftUI

struct RefreshableScrollView<Content: View>: UIViewRepresentable {
    let content: Content
    @Binding var isRefreshing: Bool
    let onRefresh: () -> Void
    
    init(isRefreshing: Binding<Bool>, onRefresh: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self._isRefreshing = isRefreshing
        self.onRefresh = onRefresh
        self.content = content()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.handleRefreshControl), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = UIColor(resource: .mainbg)
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        if isRefreshing {
            uiView.refreshControl?.beginRefreshing()
        } else {
            uiView.refreshControl?.endRefreshing()
        }
    }
    
    class Coordinator: NSObject {
        let parent: RefreshableScrollView
        
        init(_ parent: RefreshableScrollView) {
            self.parent = parent
        }
        
        @objc func handleRefreshControl(sender: UIRefreshControl) {
            if !parent.isRefreshing {
                parent.isRefreshing = true
                parent.onRefresh()
            }
        }
    }
}

