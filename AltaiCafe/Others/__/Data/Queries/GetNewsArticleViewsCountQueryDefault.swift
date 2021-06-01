//
//  GetNewsArticleViewsCountQueryDefault.swift
//  AltaiCafe
//
//  Created by Roman Baev on 29.04.2021.
//

import Foundation
import Combine

final class GetNewsArticleViewsCountQueryDefault: GetNewsArticleViewsCountQuery {
    let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func execute(articleId: ID) -> AnyPublisher<Int, GetNewsArticleViewsCountQueryError> {
        let range = [0, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5]
        let newViewsCount = range.randomElement()!
        let oldViewsCount = dependency.storage.getViewsCount(id: articleId) ?? 0
        let viewsCount = oldViewsCount + newViewsCount
        dependency.storage.setViewsCount(id: articleId, count: viewsCount)
        let randomDelay = [150, 150, 300, 300, 500].randomElement()!
        return Just(viewsCount)
            .setFailureType(to: GetNewsArticleViewsCountQueryError.self)
            .delay(for: .milliseconds(randomDelay), scheduler: DispatchQueue.global())
            .eraseToAnyPublisher()
    }
}

extension GetNewsArticleViewsCountQueryDefault {
    struct Dependency {
        let storage: ArticlesDataStorage
    }
}
