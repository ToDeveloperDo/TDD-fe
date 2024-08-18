//
//  ToolbarBtn.swift
//  TDD
//
//  Created by 최안용 on 8/17/24.
//

import SwiftUI

struct ToolbarBtn: View {
    @State var infoType: InfoType
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text("\(infoType.title)")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(Color(infoType.titleColor))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(infoType.bgColor))
                }
            
        })
        .disabled(infoType == .REQUEST)
    }
}

#Preview {
    ToolbarBtn(infoType: .RECEIVE, action: {})
}
