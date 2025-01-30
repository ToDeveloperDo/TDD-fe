//
//  CurriculumButton.swift
//  TDD
//
//  Created by 최안용 on 12/11/24.
//

import SwiftUI

struct CurriculumButton: View {
    @Environment(\.isEnabled) private var isEnabled
    
    let title: String
    let action: () -> Void
    
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.fixWh)
                Spacer()
            }
            .padding(.vertical, 18.5)
            .background(isEnabled ? Color.primary100 : Color.black50)
            .cornerRadius(10, corners: .allCorners)
        }
    }
}

