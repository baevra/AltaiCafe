//
//  ValidateEmailUseCaseTests.swift
//  AltaiCafeUITests
//
//  Created by Roman Baev on 28.05.2021.
//

import XCTest
@testable import AltaiCafe

class ValidateEmailUseCaseTests: XCTestCase {
  var sut: ValidateEmailUseCaseDefault!

  override func setUpWithError() throws {
    sut = ValidateEmailUseCaseDefault()
  }

  func testValidEmail() throws {
    // given
    let email = "example@example.com"

    // when
    let result = sut.execute(email: email)

    // then
    XCTAssertNoThrow(try result.get(), "Correct email throws error")
  }

  func testInvalidEmail() throws {
    // given
    let email = "exampleexamplecom"

    // when
    let result = sut.execute(email: email)

    // then
    XCTAssertThrowsError(try result.get(), "Incorrect email doesnt throws error")
  }
}
