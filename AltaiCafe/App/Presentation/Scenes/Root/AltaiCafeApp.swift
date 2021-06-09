//
//  AltaiCafeApp.swift
//  AltaiCafe
//
//  Created by Roman Baev on 12.04.2021.
//

import SwiftUI

@main
struct AltaiCafeApp: App {
  enum Tab: Int {
    case news
    case menu
    case profile
  }
  
  @State private var selectedTab = Tab.news
  
  var body: some Scene {
    WindowGroup {
      TabView(selection: $selectedTab) {
        newsView
          .tabItem {
            Image(systemName: "newspaper")
            Text("Новости")
          }
          .tag(Tab.news)
        Text("2")
          .tabItem {
            Image(systemName: "doc.plaintext")
            Text("Меню")
          }
          .tag(Tab.menu)
        signinView
          .tabItem {
            Image(systemName: "person")
            Text("Профиль")
          }
          .tag(Tab.profile)
      }
    }
  }
  
  var newsView: some View {
    let builder = NewsViewBuilder()
    let view = builder.build()
    return NavigationView {
      view
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
  
  var signinView: some View {
    
    let viewModel = ViewModel(
      viewModel: SigninViewModel(
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
      ),
      initialState: .empty
    )
    let builder = SigninViewBuilder(dependency: .init(viewModel: viewModel))
    let view = builder.build()
    return NavigationView {
      view
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}
