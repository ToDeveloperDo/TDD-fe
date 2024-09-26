//
//  NetworkErrorAlert.swift
//  TDD
//
//  Created by 최안용 on 8/25/24.
//

import SwiftUI

struct NetworkErrorAlert: View {
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        Text("\(title)")
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(Color.fixWh)
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.serve.opacity(0.8))
            }
    }
}

#Preview {
    NetworkErrorAlert(title: "네트워크 통신 에러")
}
