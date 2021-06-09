//
//  GetNewsArticleViewsCountUseCase.swift
//  AltaiCafe
//
//  Created by Roman Baev on 15.04.2021.
//

import Foundation
import Combine

protocol GetNewsArticleViewsCountUseCase {
  func execute(articleId: ID) -> AnyPublisher<Int, GetNewsArticleViewsCountUseCaseError>
}

enum GetNewsArticleViewsCountUseCaseError: Error {
  case unknown
}
