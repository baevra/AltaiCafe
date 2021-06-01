//
//  NewsArticleViewBuilder.swift
//  AltaiCafe
//
//  Created by Roman Baev on 16.04.2021.
//

import Foundation
import SwiftUI

final class NewsArticleViewBuilder {
    let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func build() -> some View {
        let viewModel = dependency.viewModel
        let view = NewsArticleView(viewModel: viewModel)
        return view
    }
}

extension NewsArticleViewBuilder {
    struct Dependency {
        let viewModel: ViewModel<NewsArticleViewModel>
    }
}
