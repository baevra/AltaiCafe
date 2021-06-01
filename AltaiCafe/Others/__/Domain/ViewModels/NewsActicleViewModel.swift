//
//  NewsActicleViewModel.swift
//  AltaiCafe
//
//  Created by Roman Baev on 15.04.2021.
//

import Foundation
import Combine

final class NewsArticleViewModel: ViewModelable {
    let state: CurrentValueSubject<State, Never>

    let dependency: Dependency
    var updateCountersStream: AnyCancellable?

    init(dependency: Dependency) {
        self.dependency = dependency
        self.state = .init(.init(article: dependency.article))
    }

    func dispatch(action: Action) {
        switch action {
        case .startUpdateCounters:
            fetchUpdatedCounters()
        case .stopUpdateCounters:
            updateCountersStream?.cancel()
        break
        }
    }

    private func fetchUpdatedCounters() {
        let articleId = dependency.article.id
        let getNewsArticleViewsCountUseCase = dependency.getNewsArticleViewsCountUseCase
        updateCountersStream = Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .flatMap { _ in
                getNewsArticleViewsCountUseCase
                    .execute(articleId: articleId)
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .replaceError(with: 0)
            .map(String.init)
            .assignWeakly(to: \.state.value.viewsCount, on: self)
    }
}

extension NewsArticleViewModel {
    struct Dependency {
        let article: NewsArticle
        let getNewsArticleViewsCountUseCase: GetNewsArticleViewsCountUseCase
    }
}

extension NewsArticleViewModel {
    struct State: Identifiable, Equatable {
        let id: ID
        let title: String
        let body: String
        var viewsCount: String
        var commentsCount: String

        init(article: NewsArticle) {
            self.id = article.id
            self.title = article.title
            self.body = article.body
            self.viewsCount = "\(article.viewsCount)"
            self.commentsCount = "\(article.commentsCount)"
        }
    }
}

extension NewsArticleViewModel {
    enum Action {
        case startUpdateCounters
        case stopUpdateCounters
    }
}
