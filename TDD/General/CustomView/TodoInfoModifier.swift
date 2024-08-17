//
//  TodoInfoModifier.swift
//  TDD
//
//  Created by 최안용 on 8/4/24.
//

import SwiftUI

struct TodoInfoModifier: ViewModifier {
    var type: TodoInfo
    var width: CGFloat
    
    func body(content: Content) -> some View {
        HStack {
            HStack {
                Label {
                    Text("\(type.rawValue)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.githubText)
                } icon: {
                    Image("\(type.imageName)")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 20)
                        .foregroundStyle(Color.githubText)
                }
                Spacer()
            }.frame(width: width)
            
            HStack {
                content
                Spacer()
            }
        }
    }
}

