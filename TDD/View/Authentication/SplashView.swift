//
//  LaunchScreen.swift
//  TDD
//
//  Created by 최안용 on 8/19/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
             Color.fixWh
                 .ignoresSafeArea()

             Image("appLogo")
                 .resizable()
                 .frame(width: 64, height: 66)
         }
    }
}

#Preview {
    SplashView()
}
