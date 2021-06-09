//
//  BaseState.swift
//  AltaiCafe
//
//  Created by Roman Baev on 14.04.2021.
//

import Foundation

enum BaseState<Value, Error: Swift.Error> {
  case idle
  case loading
  case success(Value)
  case error(Error)

  var isLoading: Bool {
    if case .loading = self {
      return true
    }
    return false
  }

  var data: Value? {
    guard case let .success(value) = self else {
      return nil
    }
    return value
  }

  var error: Error? {
    guard case let .error(error) = self else {
      return nil
    }

    return error
  }
}
