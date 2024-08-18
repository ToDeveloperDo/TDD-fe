//
//  UserInfoView.swift
//  TDD
//
//  Created by 최안용 on 8/13/24.
//

import SwiftUI

struct UserInfoView: View {
    var url: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Image(.profileBg)
                Color.mainbg
                    .frame(height: 65)
            }
            
            HStack {
                URLImageView(urlString: url)
                    .frame(width: 128, height: 128)
                    .background(Color.shadow)
                    .clipShape(Circle())
                Spacer()
            }
            .padding(.horizontal, 20)            
        }
        .ignoresSafeArea()
    }
}

#Preview {
    UserInfoView(url: "")
}
