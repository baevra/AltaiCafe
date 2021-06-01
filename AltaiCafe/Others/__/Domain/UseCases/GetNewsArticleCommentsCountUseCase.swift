//
//  GetNewsArticleCommentsCountUseCase.swift
//  AltaiCafe
//
//  Created by Roman Baev on 15.04.2021.
//

import Foundation
import Combine

protocol GetNewsArticleCommentsCountUseCase {
    func execute(articleId: ID) -> AnyPublisher<Int, GetNewsArticleCommentsCountUseCaseError>
}

enum GetNewsArticleCommentsCountUseCaseError: Error {
    case unknown
}
