//
//  ValidateEmailUseCase.swift
//  AltaiCafe
//
//  Created by Roman Baev on 28.05.2021.
//

import Foundation

protocol ValidateEmailUseCase {
  func execute(email: String) -> Result<Void, ValidateEmailUseCaseError>
}

enum ValidateEmailUseCaseError: Error {
  case invalid
}

final class ValidateEmailUseCaseDefault: ValidateEmailUseCase {
  func execute(email: String) -> Result<Void, ValidateEmailUseCaseError> {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let isValid = emailPredicate.evaluate(with: email)
    
    guard isValid else {
      return .failure(.invalid)
    }
    return .success(())
  }
}
