//
//  URLImageView.swift
//  TDD
//
//  Created by 최안용 on 8/7/24.
//

import SwiftUI

struct URLImageView: View {
    @EnvironmentObject var container: DIContainer
    
    let urlString: String?
    let placeholderName: String
    
    init(urlString: String?, placeholderName: String? = nil) {
        self.urlString = urlString
        self.placeholderName = placeholderName ?? "place"
    }
    
    var body: some View {
        if let urlString, !urlString.isEmpty {
            URLInnerImageView(viewModel: .init(urlString: urlString, container: container), placeholderName: placeholderName)
                .id(urlString)
        } else {
            Image(placeholderName)
                .resizable()
        }
    }
}

private struct URLInnerImageView: View {
    @StateObject var viewModel: URLImageViewModel
    
    let placeholderName: String
    
    var placeholderImage: UIImage {
        UIImage(named: placeholderName) ?? UIImage()
    }
    
    fileprivate var body: some View {
        Image(uiImage: viewModel.loadedImage ?? placeholderImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onAppear {
                if !viewModel.loadingOrSuccess {
                    viewModel.start()
                }
            }
    }
}

#Preview {
    URLImageView(urlString: nil)
}
