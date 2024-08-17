//
//  LoadingView.swift
//  TDD
//
//  Created by 최안용 on 8/2/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}

#Preview {
    LoadingView()
}
