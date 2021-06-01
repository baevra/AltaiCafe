//
//  ValidatePasswordsUseCase.swift
//  AltaiCafe
//
//  Created by Roman Baev on 28.05.2021.
//

import Foundation

protocol ValidatePasswordsUseCase {
  func execute(
    password: String,
    password2: String
  ) -> Result<Void, ValidatePasswordsUseCaseError>
}

enum ValidatePasswordsUseCaseError: Error {
  case invalid
  case notMatch
}

final class ValidatePasswordsUseCaseDefault: ValidatePasswordsUseCase {
  func execute(
    password: String,
    password2: String
  ) -> Result<Void, ValidatePasswordsUseCaseError> {
    guard password == password2 else {
      return .failure(.notMatch)
    }
    return .success(())
  }
}
