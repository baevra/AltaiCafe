//
//  GetNewsArticleCommentsCountQuery.swift
//  AltaiCafe
//
//  Created by Roman Baev on 29.04.2021.
//

import Foundation
import Combine

protocol GetNewsArticleCommentsCountQuery {
  func execute(articleId: ID) -> AnyPublisher<Int, GetNewsArticleCommentsCountQueryError>
}

enum GetNewsArticleCommentsCountQueryError: Error {
  case unknown
}
