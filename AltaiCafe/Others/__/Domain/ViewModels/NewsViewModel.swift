//
//  NewsViewModel.swift
//  AltaiCafe
//
//  Created by Roman Baev on 15.04.2021.
//

import Foundation
import Combine

final class NewsViewModel: ViewModelable {
    let state = CurrentValueSubject<State, Never>(.init())

    let dependency: Dependency
    var fetchRecenetNewsArticlesStream: AnyCancellable?

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func dispatch(action: Action) {
        switch action {
        case .onAppear:
            state.value.articles = .loading
            fetchRecenetNewsArticles()
        case .update:
            fetchRecenetNewsArticles()
        }
    }

    private func fetchRecenetNewsArticles() {
        fetchRecenetNewsArticlesStream = dependency.getRecentNewsArticlesUseCase
            .execute()
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .map(BaseState.success)
            .assignWeakly(to: \.state.value.articles, on: self)
    }
}

/*
 
 */

extension NewsViewModel {
    struct Dependency {
        let getRecentNewsArticlesUseCase: GetRecentNewsArticlesUseCase
    }
}

extension NewsViewModel {
    struct State {
        var title = "Новости"
        var articles: BaseState<[NewsArticle], Error> = .idle
    }
}

extension NewsViewModel {
    enum Action {
        case onAppear
        case update
    }
}
