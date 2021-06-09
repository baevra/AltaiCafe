//
//  NewsArticleView.swift
//  AltaiCafe
//
//  Created by Roman Baev on 16.04.2021.
//

import Foundation
import SwiftUI

struct NewsArticleView: View {
  @ObservedObject var viewModel: ViewModel<NewsArticleViewModel>
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(viewModel.state.id)
        .font(.headline)
      Text(viewModel.state.body)
        .font(.subheadline)
      HStack {
        Text(viewModel.state.viewsCount)
          .font(.footnote)
        Text(viewModel.state.commentsCount)
          .font(.footnote)
      }
      .foregroundColor(.gray)
    }
    .onAppear { [weak viewModel] in
      viewModel?.dispatch(action: .startUpdateCounters)
    }
    .onDisappear { [weak viewModel] in
      viewModel?.dispatch(action: .stopUpdateCounters)
    }
  }
}

extension NewsArticleView {
  static func skeleton() -> some View {
    VStack(alignment: .leading) {
      Text("Long title")
        .font(.headline)
      Text("Sample body text")
        .font(.subheadline)
      HStack {
        Text("20")
        Text("300")
      }
      .font(.footnote)
      .foregroundColor(.gray)
    }
    .redacted(reason: .placeholder)
  }
}
