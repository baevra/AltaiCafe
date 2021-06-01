//
//  GetRecentNewsArticlesQueryDefault.swift
//  AltaiCafe
//
//  Created by Roman Baev on 16.04.2021.
//

import Foundation
import Combine

final class GetRecentNewsArticlesQueryDefault: GetRecentNewsArticlesQuery {
    let dependency: Dependency
    var updatesCount = 0

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func execute() -> AnyPublisher<[NewsArticle], GetRecentNewsArticlesQueryError> {
        let storage = dependency.storage

        let initialNews: [NewsArticle] = [
            .init(
                id: "1",
                title: "The First",
                body: "First article",
                viewsCount: storage.getViewsCount(id: "1", default: 100..<200),
                commentsCount: storage.getCommentsCount(id: "1", default: 100..<200)
            ),
            .init(
                id: "2",
                title: "The Second",
                body: "Second article",
                viewsCount: storage.getViewsCount(id: "2", default: 100..<200),
                commentsCount: storage.getCommentsCount(id: "2", default: 100..<200)
            ),
            .init(
                id: "3",
                title: "The Second",
                body: "Second article",
                viewsCount: storage.getViewsCount(id: "3", default: 100..<200),
                commentsCount: storage.getCommentsCount(id: "3", default: 100..<200)
            ),
            .init(
                id: "4",
                title: "The Second",
                body: "Second article",
                viewsCount: storage.getViewsCount(id: "4", default: 100..<200),
                commentsCount: storage.getCommentsCount(id: "4", default: 100..<200)
            )
        ]

        let updatedNews: [NewsArticle] = initialNews + [
            .init(
                id: "5",
                title: "The Second",
                body: "Second article",
                viewsCount: storage.getViewsCount(id: "5", default: 50..<100),
                commentsCount: storage.getCommentsCount(id: "5", default: 50..<100)
            ),
            .init(
                id: "6",
                title: "The Second",
                body: "Second article",
                viewsCount: storage.getViewsCount(id: "6", default: 50..<100),
                commentsCount: storage.getCommentsCount(id: "6", default: 50..<100)
            )
        ]

        let latestNews: [NewsArticle] = initialNews + updatedNews + [
            .init(
                id: "7",
                title: "The Second",
                body: "Second article",
                viewsCount: storage.getViewsCount(id: "7", default: 0..<50),
                commentsCount: storage.getCommentsCount(id: "7", default: 0..<50)
            ),
            .init(
                id: "8",
                title: "The Second",
                body: "Second article",
                viewsCount: 0,
                commentsCount: 0
            )
        ]

        let articles: [NewsArticle]

        switch updatesCount {
        case 0:
            articles = initialNews
        case 1:
            articles = updatedNews
        default:
            articles = latestNews
        }

        updatesCount += 1

        return Just(articles.reversed())
            .setFailureType(to: GetRecentNewsArticlesQueryError.self)
            .delay(for: .milliseconds(700), scheduler: DispatchQueue.global())
            .eraseToAnyPublisher()
    }
}

extension GetRecentNewsArticlesQueryDefault {
    struct Dependency {
        let storage: ArticlesDataStorage
    }
}
