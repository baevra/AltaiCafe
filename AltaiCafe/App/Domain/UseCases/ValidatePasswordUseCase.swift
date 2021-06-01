//
//  ValidatePasswordUseCase.swift
//  AltaiCafe
//
//  Created by Roman Baev on 28.05.2021.
//

import Foundation

protocol ValidatePasswordUseCase {
  func execute(password: String) -> Result<Void, ValidatePasswordUseCaseError>
}

enum ValidatePasswordUseCaseError: Error {
  case invalid
}

final class ValidatePasswordUseCaseDefault: ValidatePasswordUseCase {
  func execute(password: String) -> Result<Void, ValidatePasswordUseCaseError> {
    guard password.count > 3 else {
      return .failure(.invalid)
    }
    return .success(())
  }
}
