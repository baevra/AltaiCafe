//
//  SigninViewBuilder.swift
//  AltaiCafe
//
//  Created by Roman Baev on 28.05.2021.
//

import Foundation
import SwiftUI

final class SigninViewBuilder {
  let dependency: Dependency

  init(dependency: Dependency) {
    self.dependency = dependency
  }

  func build() -> some View {
    let viewModel = dependency.viewModel
    let view = SigninView(viewModel: viewModel)
    return view
  }
}

extension SigninViewBuilder {
  struct Dependency {
    let viewModel: ViewModel<SigninViewModel>
  }
}
