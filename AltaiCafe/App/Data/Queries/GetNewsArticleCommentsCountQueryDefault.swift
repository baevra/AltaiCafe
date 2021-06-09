//
//  GetNewsArticleCommentsCountQueryDefault.swift
//  AltaiCafe
//
//  Created by Roman Baev on 29.04.2021.
//

import Foundation
import Combine

final class GetNewsArticleCommentsCountQueryDefault: GetNewsArticleCommentsCountQuery {
  let dependency: Dependency
  
  init(dependency: Dependency) {
    self.dependency = dependency
  }
  
  func execute(articleId: ID) -> AnyPublisher<Int, GetNewsArticleCommentsCountQueryError> {
    let range = [0, 0, 0, 0, 0, 1, 1, 1, 2, 3]
    let newCommentsCount = range.randomElement() ?? 0
    let oldCommentsCount = dependency.storage.getCommentsCount(id: articleId) ?? 0
    let commentsCount = oldCommentsCount + newCommentsCount
    dependency.storage.setCommentsCount(id: articleId, count: commentsCount)
    let randomDelay = [150, 150, 300, 300, 500].randomElement()!
    return Just(commentsCount)
      .setFailureType(to: GetNewsArticleCommentsCountQueryError.self)
      .delay(for: .milliseconds(randomDelay), scheduler: DispatchQueue.global())
      .eraseToAnyPublisher()
  }
}

extension GetNewsArticleCommentsCountQueryDefault {
  struct Dependency {
    let storage: ArticlesDataStorage
  }
}
