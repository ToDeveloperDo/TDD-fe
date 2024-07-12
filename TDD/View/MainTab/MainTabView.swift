//
//  MainTabView.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: MainTabType = .calendar
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                ForEach(MainTabType.allCases, id: \.self) { tab in
                    Group {
                        switch tab {
                        case .calendar:
                            CalendarView(viewModel: CalendarViewModel())
                        case .myInfo:
                            MyInfoView()
                        case .todo:
                            UnKnownView()
                        }
                    }
                    .tabItem {
                        Label(tab.title, systemImage: tab.systemImageName)
                    }
                    .tag(tab)
                }
            }
            
        }
        
    }
}

#Preview {
    MainTabView()
}
