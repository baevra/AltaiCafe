//
//  GetNewsArticleCommentsCountUseCaseDefault.swift
//  AltaiCafe
//
//  Created by Roman Baev on 29.04.2021.
//

import Foundation
import Combine

final class GetNewsArticleCommentsCountUseCaseDefault: GetNewsArticleCommentsCountUseCase {
    let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func execute(articleId: ID) -> AnyPublisher<Int, GetNewsArticleCommentsCountUseCaseError> {
        return dependency.getNewsArticleCommentsCountQuery
            .execute(articleId: articleId)
            .mapError { _ in GetNewsArticleCommentsCountUseCaseError.unknown }
            .eraseToAnyPublisher()
    }
}

extension GetNewsArticleCommentsCountUseCaseDefault {
    struct Dependency {
        let getNewsArticleCommentsCountQuery: GetNewsArticleCommentsCountQuery
    }
}
