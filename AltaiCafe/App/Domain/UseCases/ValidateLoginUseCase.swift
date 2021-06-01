//
//  ValidateLoginUseCase.swift
//  AltaiCafe
//
//  Created by Roman Baev on 28.05.2021.
//

import Foundation

protocol ValidateLoginUseCase {
  func execute(login: String) -> Result<Void, ValidateLoginUseCaseError>
}

enum ValidateLoginUseCaseError: Error {
  case invalid
}

final class ValidateLoginUseCaseDefault: ValidateLoginUseCase {
  func execute(login: String) -> Result<Void, ValidateLoginUseCaseError> {
    return .success(())
  }
}
