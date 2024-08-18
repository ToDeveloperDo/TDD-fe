//
//  RefreshableScrollView.swift
//  TDD
//
//  Created by 최안용 on 8/16/24.
//

import SwiftUI

struct RefreshableScrollView<Content: View>: View {
    @Binding var isRefreshing: Bool
    let onRefresh: () -> Void
    let content: () -> Content
    
    init(isRefreshing: Binding<Bool>, onRefresh: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self._isRefreshing = isRefreshing
        self.onRefresh = onRefresh
        self.content = content
    }
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                // Pull to refresh
                RefreshControl(isRefreshing: $isRefreshing, onRefresh: onRefresh)
                
                // Content
                content()
            }
        }
    }
}

struct RefreshControl: UIViewRepresentable {
    @Binding var isRefreshing: Bool
    let onRefresh: () -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.handleRefreshControl), for: .valueChanged)
        context.coordinator.refreshControl = refreshControl
        
        DispatchQueue.main.async {
            view.addSubview(refreshControl)
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if isRefreshing {
            context.coordinator.refreshControl?.beginRefreshing()
        } else {
            context.coordinator.refreshControl?.endRefreshing()
        }
    }
    
    class Coordinator: NSObject {
        var parent: RefreshControl
        var refreshControl: UIRefreshControl?
        
        init(parent: RefreshControl) {
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
