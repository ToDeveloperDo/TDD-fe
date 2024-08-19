//
//  TodoInfoModifier.swift
//  TDD
//
//  Created by 최안용 on 8/4/24.
//

import SwiftUI

struct TodoInfoModifier: ViewModifier {
    var type: TodoInfo
    
    func body(content: Content) -> some View {
        HStack(spacing: 36) {
            HStack(spacing: 16) {
                Image("\(type.imageName)")
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("\(type.rawValue)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.serve)
            }
            .frame(width: 60)
            
            HStack {
                content
                Spacer()
            }
        }
    }
}

