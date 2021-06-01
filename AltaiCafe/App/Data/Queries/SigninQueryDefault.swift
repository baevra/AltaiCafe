//
//  SigninQueryDefault.swift
//  AltaiCafe
//
//  Created by Roman Baev on 28.05.2021.
//

import Foundation
import Combine

final class SigninQueryDefault: SigninQuery {
  func execute(
    email: String,
    login: String,
    password: String
  ) -> AnyPublisher<Void, SigninUseCaseError> {
    return Just(())
      .setFailureType(to: SigninUseCaseError.self)
      .delay(for: .milliseconds(700), scheduler: DispatchQueue.global())
      .eraseToAnyPublisher()
  }
}
