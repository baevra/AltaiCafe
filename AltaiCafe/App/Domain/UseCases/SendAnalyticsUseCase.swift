//
//  SendAnalyticsUseCase.swift
//  AltaiCafe
//
//  Created by Roman Baev on 28.05.2021.
//

import Foundation
import Combine

protocol SendAnalyticsUseCase {
  func execute(code: String) -> AnyPublisher<Void, SendAnalyticsUseCaseError>
}

enum SendAnalyticsUseCaseError: Error {
  case unknown
}

final class SendAnalyticsUseCaseDefault: SendAnalyticsUseCase {
  func execute(code: String) -> AnyPublisher<Void, SendAnalyticsUseCaseError> {
    return Just(())
      .setFailureType(to: SendAnalyticsUseCaseError.self)
      .delay(for: .milliseconds(700), scheduler: DispatchQueue.global())
      .eraseToAnyPublisher()
  }
}

final class SendAnalyticsUseCaseMock: SendAnalyticsUseCase {
  var executeRequestCompletionCallsCount = 0
  var executeRequestCompletionCalled: Bool {
    return executeRequestCompletionCallsCount > 0
  }
  var executeRequestCompletionReceivedArguments: String?
  var executeRequestCompletionReceivedInvocations: [String] = []
  var executeRequestCompletionClosure: ((String, @escaping (Result<Void, SendAnalyticsUseCaseError>) -> Void) -> Void)?
  
  func execute(code: String) -> AnyPublisher<Void, SendAnalyticsUseCaseError> {
    executeRequestCompletionCallsCount += 1
    executeRequestCompletionReceivedArguments = code
    executeRequestCompletionReceivedInvocations.append(code)
    return Future { [unowned self] promise in
      self.executeRequestCompletionClosure?(code) { result in
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
