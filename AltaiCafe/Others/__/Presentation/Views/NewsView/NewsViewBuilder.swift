//
//  NewsViewBuilder.swift
//  AltaiCafe
//
//  Created by Roman Baev on 15.04.2021.
//

import Foundation
import SwiftUI

final class NewsViewBuilder {
    func build() -> some View {
        let getRecentNewsArticlesQuery = GetRecentNewsArticlesQueryDefault(
            dependency: .init(storage: .shared)
        )
        let getRecentNewsArticlesUseCase = GetRecentNewsArticlesUseCaseDefault(
            dependency: .init(getRecentNewsArticlesQuery: getRecentNewsArticlesQuery)
        )
        let newsViewModel = NewsViewModel(
            dependency: .init(getRecentNewsArticlesUseCase: getRecentNewsArticlesUseCase)
        )
        let viewModel = ViewModel(viewModel: newsViewModel, initialState: .init())

        let forEachBuilder = ForEachBuilder<NewsArticle, NewsArticleViewBuilder>(
            dependency: .init(buildChild: buildNewsArticleViewBuilder)
        )
        let view = NewsView(
            viewModel: viewModel,
            forEachNewsArticleViewBuilder: forEachBuilder
        )
        return view
    }

    func buildNewsArticleViewBuilder(article: NewsArticle) -> NewsArticleViewBuilder {
        let getNewsArticleViewsCountQuery = GetNewsArticleViewsCountQueryDefault(
            dependency: .init(storage: .shared)
        )
        let getNewsArticleViewsCountUseCase = GetNewsArticleViewsCountUseCaseDefault(
            dependency: .init(
                getNewsArticleViewsCountQuery: getNewsArticleViewsCountQuery
            )
        )
        let newsArticleViewModel = NewsArticleViewModel(
            dependency: .init(
                article: article,
                getNewsArticleViewsCountUseCase: getNewsArticleViewsCountUseCase
            )
        )
        let viewModel = ViewModel(
            viewModel: newsArticleViewModel,
            initialState: newsArticleViewModel.state.value
        )
        let builder = NewsArticleViewBuilder(
            dependency: .init(viewModel: viewModel)
        )
        return builder
    }
}
