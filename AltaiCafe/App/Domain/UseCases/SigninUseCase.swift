//
//  SigninUseCase.swift
//  AltaiCafe
//
//  Created by Roman Baev on 28.05.2021.
//

import Foundation
import Combine

protocol SigninUseCase {
  func execute(
    email: String,
    login: String,
    password: String
  ) -> AnyPublisher<Void, SigninUseCaseError>
}

enum SigninUseCaseError: Error {
  case unknown
  case analytics
  case invalidCredentials
}

final class SigninUseCaseDefault: SigninUseCase {
  let dependency: Dependency

  init(dependency: Dependency) {
    self.dependency = dependency
  }

  func execute(
    email: String,
    login: String,
    password: String
  ) -> AnyPublisher<Void, SigninUseCaseError> {
    return dependency.signinQuery
      .execute(email: email, login: login, password: password)
      .flatMap { [unowned self] in
        self.dependency.sendAnalyticsUseCase
          .execute(code: "SIGNIN_SUCCESS")
          .mapError { _ in SigninUseCaseError.analytics }
          .eraseToAnyPublisher()
      }
      .mapError { $0 as Error }
      .mapError { error in
        if let error = error as? SigninUseCaseError {
          return error
        }
        return SigninUseCaseError.unknown
      }
      .eraseToAnyPublisher()
  }
}

extension SigninUseCaseDefault {
  struct Dependency {
    let signinQuery: SigninQuery
    let sendAnalyticsUseCase: SendAnalyticsUseCase
  }
}

final class SigninUseCaseMock: SigninUseCase {
  var executeRequestCompletionCallsCount = 0
  var executeRequestCompletionCalled: Bool {
      return executeRequestCompletionCallsCount > 0
  }
  var executeRequestCompletionReceivedArguments: (email: String, login: String, password: String)?
  var executeRequestCompletionReceivedInvocations: [(email: String, login: String, password: String)] = []
  var executeRequestCompletionClosure: (((email: String, login: String, password: String), @escaping (Result<Void, SigninUseCaseError>) -> Void) -> Void)?

  func execute(
    email: String,
    login: String,
    password: String
  ) -> AnyPublisher<Void, SigninUseCaseError> {
    executeRequestCompletionCallsCount += 1
    executeRequestCompletionReceivedArguments = (email, login, password)
    executeRequestCompletionReceivedInvocations.append((email, login, password))
    return Future { [unowned self] promise in
      self.executeRequestCompletionClosure?((email, login, password)) { result in
        switch result {
        case let .success(result):
          return promise(.success(result))
        case let .failure(error):
          return promise(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}
