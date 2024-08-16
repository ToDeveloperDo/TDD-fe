//
//  MyInfoView.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import SwiftUI

struct MyProfileView: View {
    @StateObject var viewModel: MyProfileViewModel
    @State private var isRefreshing = false
    private let columns = Array(repeating: GridItem(.fixed(170)), count: 2)
    
    var body: some View {
        NavigationView {
            RefreshableScrollView(isRefreshing: $isRefreshing) {
                self.refresh()
            } content: {
                VStack(spacing: 0) {
                    MyProfileCell(viewModel: viewModel)
                        .padding(.top, 115)
                        .background(Color.fixWh)
                    
                    BtnView(viewModel: viewModel)
                    
                    SearchBar(text: $viewModel.searchName) {
                        
                    }
                    .padding(.bottom, 14)
                    .padding(.horizontal, 24)
                    .background(Color.mainbg)
                    
                    if viewModel.users.isEmpty {
                        VStack {
                            Spacer()
                            Text("없음")
                            Spacer()
                        }
                    } else {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(viewModel.users) { user in
                                UserInfoCardView(user: user) {
                                    viewModel.accept(id: user.userId)
                                } action2: {
                                    viewModel.send(id: user.userId)
                                }
                                
                            }
                        }
                        .background(Color.mainbg)
                    }
                    
                    
                }
            }
            .ignoresSafeArea()
            .background(Color.white.edgesIgnoringSafeArea(.bottom))
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        // TODO: -
                    }, label: {
                        Image(.settingIcon)
                    })
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.fixWh, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            
           

        }
    }
    private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isRefreshing = false
        }
    }
}

private struct MyProfileCell: View {
    @ObservedObject private var viewModel: MyProfileViewModel
    
    init(viewModel: MyProfileViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            UserInfoView(url: viewModel.myInfo?.profileUrl ?? "")
                .padding(.bottom, 28)
            Text("\(viewModel.myInfo?.name ?? "이름")")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(Color.text)
                .padding(.bottom, 8)
                .padding(.horizontal, 24)
            Button(action: {
                
            }, label: {
                Text("\(viewModel.myInfo?.gitUrl ?? "url")")
                    .font(.system(size: 14, weight: .light))
                    .tint(Color.text)
            })
            .padding(.horizontal, 24)
        }
        .padding(.bottom, 17)
        .background(Color.mainbg)
    }
}



private struct BtnView: View {
    @ObservedObject private var viewModel: MyProfileViewModel
    
    init(viewModel: MyProfileViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        HStack {
            HStack(spacing: 16) {
                MyProfileBtn(type: .friend, selected: viewModel.selectedMode == .friend) {
                    viewModel.send(action: .clickedBtn(mode: .friend))
                }
                
                MyProfileBtn(type: .request, selected: viewModel.selectedMode == .request) {
                    viewModel.send(action: .clickedBtn(mode: .request))
                }
                
                MyProfileBtn(type: .receive, selected: viewModel.selectedMode == .receive) {
                    viewModel.send(action: .clickedBtn(mode: .receive))
                }
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 12)
        .background(Color.mainbg)
    }
}

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
#Preview {
    NavigationStack {
        MyProfileView(viewModel: .init(users: [.stu1, .stu2, .stu3, .stu4], container: .stub))
    }
}
