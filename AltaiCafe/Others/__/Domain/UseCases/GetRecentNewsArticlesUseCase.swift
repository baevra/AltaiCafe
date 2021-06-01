//
//  GetRecentNewsArticlesUseCase.swift
//  AltaiCafe
//
//  Created by Roman Baev on 15.04.2021.
//

import Foundation
import Combine

protocol GetRecentNewsArticlesUseCase {
    func execute() -> AnyPublisher<[NewsArticle], GetRecentNewsArticlesUseCaseError>
}

enum GetRecentNewsArticlesUseCaseError: Error {
    case unknown
}

 
