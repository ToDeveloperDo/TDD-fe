//
//  SearchEmptyView.swift
//  TDD
//
//  Created by 최안용 on 8/25/24.
//

import SwiftUI

struct SearchEmptyView: View {
    var body: some View {
        VStack {
            Image(.friendEmpty)
                .resizable()
                .frame(width: 76, height: 75)
            Text("일치하는 유저가 없어요")
                .font(.system(size: 14, weight: .light))
                .foregroundStyle(Color.serve)
        }
    }
}

#Preview {
    SearchEmptyView()
}
