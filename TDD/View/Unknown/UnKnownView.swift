//
//  UnKnownView.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import SwiftUI

struct ContentView: View {


    var body: some View {
        VStack {
            Image(systemName: "calendar")
        }
        .toolbarBackground(.hidden, for: .tabBar)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
