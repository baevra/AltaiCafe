//
//  SigninQuery.swift
//  AltaiCafe
//
//  Created by Roman Baev on 28.05.2021.
//

import Foundation
import Combine

protocol SigninQuery {
  func execute(
    email: String,
    login: String,
    password: String
  ) -> AnyPublisher<Void, SigninUseCaseError>
}

enum SigninQueryError {
  case unknown
}
