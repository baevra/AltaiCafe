//
//  NewsView.swift
//  AltaiCafe
//
//  Created by Roman Baev on 15.04.2021.
//

import Foundation
import SwiftUI
import Combine

struct NewsView: View {
  @ObservedObject var viewModel: ViewModel<NewsViewModel>
  let forEachNewsArticleViewBuilder: ForEachBuilder<NewsArticle, NewsArticleViewBuilder>
  
  var body: some View {
    List {
      switch viewModel.state.articles {
      case .idle, .loading:
        ForEach(0..<10) { _ in
          NewsArticleView.skeleton()
        }
      case let .success(articles):
        forEachNewsArticleViewBuilder.build(items: articles) { builder in
          builder.build()
        }
      case .error:
        Text("Oops")
      }
    }
    .navigationBarTitle(viewModel.state.title)
    .navigationBarItems(trailing: refreshBarItem)
    .onAppear {
      if case .idle = viewModel.state.articles {
        viewModel.dispatch(action: .onAppear)
      }
    }
  }
  
  var refreshBarItem: some View {
    Button("Обновить") {
      viewModel.dispatch(action: .update)
    }
  }
}
