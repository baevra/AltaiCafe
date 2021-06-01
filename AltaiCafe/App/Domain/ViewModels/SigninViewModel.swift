//
//  SigninViewModel.swift
//  AltaiCafe
//
//  Created by Roman Baev on 28.05.2021.
//

import Foundation
import Combine

final class SigninViewModel: ViewModelable {
  let state = CurrentValueSubject<State, Never>(.empty)

  private(set) var draftSubject = CurrentValueSubject<SigninDraft, Never>(.empty)

  let dependency: Dependency
  var signinStream: AnyCancellable?
  var subscriptions = Set<AnyCancellable>()

  init(dependency: Dependency) {
    self.dependency = dependency

    self.draftSubject
      .compactMap { $0 }
      .sink(receiveValue: updateState(draft:))
      .store(in: &subscriptions)
  }

  func dispatch(action: Action) {
    switch action {
    case let .setEmail(value):
      draftSubject.value.email = value
    case let .setLogin(value):
      draftSubject.value.login = value
    case let .setPassword(value):
      draftSubject.value.password = value
    case let .setPassword2(value):
      draftSubject.value.password2 = value
    case .signin:
      signin()
    }
  }

  func signin() {
    state.value.signin = .loading

    signinStream = dependency.signinUseCase
      .execute(
        email: draftSubject.value.email,
        login: draftSubject.value.login,
        password: draftSubject.value.password
      )
      .subscribe(on: DispatchQueue.global(qos: .userInitiated))
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [unowned self] completion in
          guard case let .failure(error) = completion else { return }
          self.state.value.signin = .error(error)
        },
        receiveValue: { [unowned self] _ in
          self.state.value.signin = .success(())
        }
      )
  }

  func updateState(draft: SigninDraft) {
    var emailError: String?
    let emailValidationResult = dependency.validateEmailUseCase
      .execute(email: draft.email)
    if case .failure = emailValidationResult,
       state.value.form.email.isTouched {
      emailError = "неверный формат"
    }

    var loginError: String?
    let loginValidationResult = dependency.validateLoginUseCase
      .execute(login: draft.login)
    if case .failure = loginValidationResult,
       state.value.form.login.isTouched {
      loginError = "неверный формат"
    }

    var passwordError: String?
    let passwordValidationResult = dependency.validatePasswordUseCase
      .execute(password: draft.password)
    if case .failure = passwordValidationResult,
       draft.password.count > 0 {
      passwordError = "неверный формат"
    }

    var passwordsError: String?
    let passwordsValidationResult = dependency.validatePasswordsUseCase
      .execute(password: draft.password, password2: draft.password2)
    if case .failure = passwordsValidationResult,
       passwordError == nil,
       draft.password2.count > 0
    {
      passwordsError = "пароли не совпадают"
    }

    state.value.form = .init(
      email: .init(value: draft.email, isTouched: draft.email.count > 0, error: emailError),
      login: .init(value: draft.login, isTouched: draft.login.count > 0, error: loginError),
      password: .init(value: draft.password, isTouched: draft.password.count > 0, error: passwordError),
      password2: .init(value: draft.password2, isTouched: draft.password2.count > 0, error: passwordsError)
    )
  }
}

extension SigninViewModel {
  struct Dependency {
    let validateEmailUseCase: ValidateEmailUseCase
    let validateLoginUseCase: ValidateLoginUseCase
    let validatePasswordUseCase: ValidatePasswordUseCase
    let validatePasswordsUseCase: ValidatePasswordsUseCase
    let signinUseCase: SigninUseCase
  }
}

extension SigninViewModel {
  struct State {
    var form: FormState
    var signin: BaseState<Void, Error>

    struct FormState {
      var email: FieldState
      var login: FieldState
      var password: FieldState
      var password2: FieldState
      var isValid: Bool {
        return email.error == nil && email.isTouched
          && login.error == nil  && login.isTouched
          && password.error == nil && password.isTouched
          && password2.error == nil  && password2.isTouched
      }

      static var empty: Self {
        return .init(
          email: .empty,
          login: .empty,
          password: .empty,
          password2: .empty
        )
      }
    }

    struct FieldState {
      var value: String
      var isTouched: Bool
      var error: String?

      static var empty: Self {
        return .init(value: "", isTouched: false, error: nil)
      }
    }

    static var empty: Self {
      return .init(
        form: .empty,
        signin: .idle
      )
    }
  }
}

extension SigninViewModel {
  enum Action {
    case signin
    case setEmail(value: String)
    case setLogin(value: String)
    case setPassword(value: String)
    case setPassword2(value: String)
  }
}
