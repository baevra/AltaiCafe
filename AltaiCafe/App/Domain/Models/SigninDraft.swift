//
//  SigninDraft.swift
//  AltaiCafe
//
//  Created by Roman Baev on 28.05.2021.
//

import Foundation

struct SigninDraft {
  var email: String
  var login: String
  var password: String
  var password2: String

  static var empty: Self {
    return .init(
      email: "",
      login: "",
      password: "",
      password2: ""
    )
  }
}
