//
//  GetNewsArticleViewsCountQuery.swift
//  AltaiCafe
//
//  Created by Roman Baev on 29.04.2021.
//

import Foundation
import Combine

protocol GetNewsArticleViewsCountQuery {
  func execute(articleId: ID) -> AnyPublisher<Int, GetNewsArticleViewsCountQueryError>
}

enum GetNewsArticleViewsCountQueryError: Error {
  case unknown
}
