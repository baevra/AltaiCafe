//
//  GetRecentNewsArticlesUseCaseDefault.swift
//  AltaiCafe
//
//  Created by Roman Baev on 16.04.2021.
//

import Foundation
import Combine

final class GetRecentNewsArticlesUseCaseDefault: GetRecentNewsArticlesUseCase {
    let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func execute() -> AnyPublisher<[NewsArticle], GetRecentNewsArticlesUseCaseError> {
        return dependency.getRecentNewsArticlesQuery
            .execute()
            .mapError { _ in GetRecentNewsArticlesUseCaseError.unknown }
            .eraseToAnyPublisher()
    }
}

extension GetRecentNewsArticlesUseCaseDefault {
    struct Dependency {
        let getRecentNewsArticlesQuery: GetRecentNewsArticlesQuery
    }
}
