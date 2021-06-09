//
//  GetNewsArticleViewsCountUseCaseDefault.swift
//  AltaiCafe
//
//  Created by Roman Baev on 16.04.2021.
//

import Foundation
import Combine

final class GetNewsArticleViewsCountUseCaseDefault: GetNewsArticleViewsCountUseCase {
  let dependency: Dependency
  
  init(dependency: Dependency) {
    self.dependency = dependency
  }
  
  func execute(articleId: ID) -> AnyPublisher<Int, GetNewsArticleViewsCountUseCaseError> {
    return dependency.getNewsArticleViewsCountQuery
      .execute(articleId: articleId)
      .mapError { _ in GetNewsArticleViewsCountUseCaseError.unknown }
      .eraseToAnyPublisher()
  }
}

extension GetNewsArticleViewsCountUseCaseDefault {
  struct Dependency {
    let getNewsArticleViewsCountQuery: GetNewsArticleViewsCountQuery
  }
}
