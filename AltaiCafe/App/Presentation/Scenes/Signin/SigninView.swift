//
//  SigninView.swift
//  AltaiCafe
//
//  Created by Roman Baev on 28.05.2021.
//

import Foundation
import SwiftUI

struct SigninView: View {
  @ObservedObject var viewModel: ViewModel<SigninViewModel>
  
  var body: some View {
    VStack {
      InputGroup {
        HStack {
          TextField(
            "Почта",
            text: .init(
              get: { viewModel.state.form.email.value },
              set: { viewModel.dispatch(action: .setEmail(value: $0)) }
            )
          )
          .keyboardType(.emailAddress)
        }
        if let error = viewModel.state.form.email.error {
          InputError(error)
        }
      }
      InputGroup {
        HStack {
          TextField(
            "Логин",
            text: .init(
              get: { viewModel.state.form.login.value },
              set: { viewModel.dispatch(action: .setLogin(value: $0)) }
            )
          )
        }
        if let error = viewModel.state.form.login.error {
          InputError(error)
        }
      }
      InputGroup {
        SecureField(
          "Пароль",
          text: .init(
            get: { viewModel.state.form.password.value },
            set: { viewModel.dispatch(action: .setPassword(value: $0)) }
          )
        )
        if let error = viewModel.state.form.password.error {
          InputError(error)
        }
      }
      InputGroup {
        SecureField(
          "Повторите пароль",
          text: .init(
            get: { viewModel.state.form.password2.value },
            set: { viewModel.dispatch(action: .setPassword2(value: $0)) }
          )
        )
        if let error = viewModel.state.form.password2.error {
          InputError(error)
        }
      }
      
      Button("Создать") {
        viewModel.dispatch(action: .signin)
      }
      .disabled(viewModel.state.signin.isLoading || !viewModel.state.form.isValid)
      .padding(.top, 20)
      
      if case .success = viewModel.state.signin {
        Text("Аккаунт успешно создан")
          .foregroundColor(.green)
          .padding(.top, 40)
      }
    }
    .navigationTitle("Создать аккаунт")
    .textFieldStyle(RoundedBorderTextFieldStyle())
    .padding()
  }
}
