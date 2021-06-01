//
//  SigninViewModelTests.swift
//  AltaiCafeTests
//
//  Created by Roman Baev on 28.05.2021.
//

import XCTest
import Combine
@testable import AltaiCafe

class SigninViewModelTests: XCTestCase {
  var sut: SigninViewModel!
  var subscriptions: Set<AnyCancellable>!

  override func setUpWithError() throws {
    subscriptions = []
    sut = SigninViewModel(
      dependency: .init(
        validateEmailUseCase: ValidateEmailUseCaseDefault(),
        validateLoginUseCase: ValidateLoginUseCaseDefault(),
        validatePasswordUseCase: ValidatePasswordUseCaseDefault(),
        validatePasswordsUseCase: ValidatePasswordsUseCaseDefault(),
        signinUseCase: SigninUseCaseDefault(
          dependency: .init(
            signinQuery: SigninQueryDefault(),
            sendAnalyticsUseCase: SendAnalyticsUseCaseDefault()
          )
        )
      )
    )
  }

  func testEmptyState() throws {
    // given
    var state: SigninViewModel.State = sut.state.value
    let emptyState: SigninViewModel.State = .empty
    let expectation = self.expectation(description: #function)

    sut.state
      .sink {
        state = $0
        expectation.fulfill()
      }
      .store(in: &subscriptions)

    // when
    // nothing

    // then
    waitForExpectations(timeout: 10)

    XCTAssertEqual(state.form.email.value, emptyState.form.email.value)
    XCTAssertEqual(state.form.login.value, emptyState.form.login.value)
    XCTAssertEqual(state.form.password.value, emptyState.form.login.value)
  }

  func testSetEmail() throws {
    // given
    var state: SigninViewModel.State = sut.state.value
    let email = "example1@email.com"
    let action = SigninViewModel.Action.setEmail(value: email)
    let expectation = self.expectation(description: #function)

    sut.state
      .dropFirst()
      .sink {
        state = $0
        expectation.fulfill()
      }
      .store(in: &subscriptions)

    // when
    sut.dispatch(action: action)

    // then
    waitForExpectations(timeout: 10)
    XCTAssertEqual(state.form.email.value, email)
  }

  func testEmailError() throws {
    // given
    var state: SigninViewModel.State = sut.state.value
    let emailTyping = "ex"
    let email = "exampleemailcom"
    let expectation = self.expectation(description: #function)

    sut.state
      .dropFirst(2)
      .sink {
        state = $0
        expectation.fulfill()
      }
      .store(in: &subscriptions)

    // when
    sut.dispatch(action: .setEmail(value: emailTyping))
    sut.dispatch(action: .setEmail(value: email))

    // then
    waitForExpectations(timeout: 10)
    XCTAssertNotNil(state.form.email.error, "Email error not equal to nil")
  }

  func testSigninSuccess() throws {
    // given
    var state: SigninViewModel.State = .init(
      form: .init(
        email: .init(value: "example@email.com", isTouched: true, error: nil),
        login: .init(value: "user", isTouched: true, error: nil),
        password: .init(value: "secret43", isTouched: true, error: nil),
        password2: .init(value: "secret43", isTouched: true, error: nil)
      ),
      signin: .idle
    )
    sut = SigninViewModel(
      dependency: .init(
        validateEmailUseCase: ValidateEmailUseCaseDefault(),
        validateLoginUseCase: ValidateLoginUseCaseDefault(),
        validatePasswordUseCase: ValidatePasswordUseCaseDefault(),
        validatePasswordsUseCase: ValidatePasswordsUseCaseDefault(),
        signinUseCase: SigninUseCaseDefault(
          dependency: .init(
            signinQuery: SigninQueryDefault(),
            sendAnalyticsUseCase: SendAnalyticsUseCaseDefault()
          )
        )
      )
    )
    sut.state.value = state
    let expectation = self.expectation(description: #function)

    sut.state
      .sink {
        state = $0
        if case .success = state.signin {
          expectation.fulfill()
        }
      }
      .store(in: &subscriptions)

    // when
    sut.dispatch(action: .signin)

    // then
    waitForExpectations(timeout: 10)
    XCTAssertNotNil(state.signin.data)
  }

  func testSigninFailure() throws {
    // given
    var state: SigninViewModel.State = .init(
      form: .init(
        email: .init(value: "example@email.com", isTouched: true, error: nil),
        login: .init(value: "user", isTouched: true, error: nil),
        password: .init(value: "secret43", isTouched: true, error: nil),
        password2: .init(value: "secret43", isTouched: true, error: nil)
      ),
      signin: .idle
    )
    let signinUseCase = SigninUseCaseMock()
    signinUseCase.executeRequestCompletionClosure = { _, completion in
      completion(.failure(.invalidCredentials))
    }
    sut = SigninViewModel(
      dependency: .init(
        validateEmailUseCase: ValidateEmailUseCaseDefault(),
        validateLoginUseCase: ValidateLoginUseCaseDefault(),
        validatePasswordUseCase: ValidatePasswordUseCaseDefault(),
        validatePasswordsUseCase: ValidatePasswordsUseCaseDefault(),
        signinUseCase: signinUseCase
      )
    )
    let expectation = self.expectation(description: #function)

    sut.state
      .sink {
        state = $0
        print(state)
        if case .error = state.signin {
          expectation.fulfill()
        }
      }
      .store(in: &subscriptions)

    // when
    sut.dispatch(action: .signin)

    // then
    waitForExpectations(timeout: 10)
    XCTAssertNotNil(state.signin.error)

    XCTAssertEqual(signinUseCase.executeRequestCompletionCallsCount, 1)

    guard let error = state.signin.error as? SigninUseCaseError else {
      XCTAssertTrue(false, "Error type not equal to SigninUseCaseError")
      return
    }
    if case .invalidCredentials = error {
      XCTAssertTrue(true)
    } else {
      XCTAssertTrue(false, "Error type not equal to invalidCredentials")
    }
  }

  func testSigninAnalyticsFailure() throws {
    // given
    var state: SigninViewModel.State = .init(
      form: .init(
        email: .init(value: "example@email.com", isTouched: true, error: nil),
        login: .init(value: "user", isTouched: true, error: nil),
        password: .init(value: "secret43", isTouched: true, error: nil),
        password2: .init(value: "secret43", isTouched: true, error: nil)
      ),
      signin: .idle
    )
    let sendAnalyticsUseCase = SendAnalyticsUseCaseMock()
    sendAnalyticsUseCase.executeRequestCompletionClosure = { _, completion in
      return completion(.failure(.unknown))
    }
    sut = SigninViewModel(
      dependency: .init(
        validateEmailUseCase: ValidateEmailUseCaseDefault(),
        validateLoginUseCase: ValidateLoginUseCaseDefault(),
        validatePasswordUseCase: ValidatePasswordUseCaseDefault(),
        validatePasswordsUseCase: ValidatePasswordsUseCaseDefault(),
        signinUseCase: SigninUseCaseDefault(
          dependency: .init(
            signinQuery: SigninQueryDefault(),
            sendAnalyticsUseCase: sendAnalyticsUseCase
          )
        )
      )
    )
    let expectation = self.expectation(description: #function)

    sut.state
      .sink {
        state = $0
        print(state)
        if case .error = state.signin {
          expectation.fulfill()
        }
      }
      .store(in: &subscriptions)

    // when
    sut.dispatch(action: .signin)

    // then
    waitForExpectations(timeout: 10)
    XCTAssertNotNil(state.signin.error)

    guard let error = state.signin.error as? SigninUseCaseError else {
      XCTAssertTrue(false, "Error type not equal to SigninUseCaseError")
      return
    }
    if case .analytics = error {
      XCTAssertTrue(true)
    } else {
      XCTAssertTrue(false, "Error type not equal to analytics")
    }
  }
}
