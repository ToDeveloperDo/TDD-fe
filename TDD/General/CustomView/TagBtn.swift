//
//  TagBtn.swift
//  TDD
//
//  Created by 최안용 on 8/9/24.
//

import SwiftUI

struct TagBtn: View {
    private var action: () -> Void
    private var title: String
    
    init(action: @escaping () -> Void, title: String) {
        self.action = action
        self.title = title
    }
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack {
                Image(.icTag)
                    .resizable()
                    .frame(width: 14, height: 14)
                    
                Text("\(title)")
                    .font(.system(size: 14, weight: .thin))
                    .foregroundStyle(.fixBk)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(RoundedRectangle(cornerRadius: 8).fill(.tagfill))
        })
    }
}

#Preview {
    TagBtn(action: {}, title: "디자인")
}
