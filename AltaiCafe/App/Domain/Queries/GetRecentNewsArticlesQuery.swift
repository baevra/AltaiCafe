//
//  GetRecentNewsArticlesQuery.swift
//  AltaiCafe
//
//  Created by Roman Baev on 15.04.2021.
//

import Foundation
import Combine

protocol GetRecentNewsArticlesQuery {
  func execute() -> AnyPublisher<[NewsArticle], GetRecentNewsArticlesQueryError>
}

enum GetRecentNewsArticlesQueryError: Error {
  case unknown
}
