//
//  NewsArticle.swift
//  AltaiCafe
//
//  Created by Roman Baev on 15.04.2021.
//

import Foundation

struct NewsArticle: Identifiable, Hashable {
  let id: ID
  let title: String
  let body: String
  var viewsCount: Int
  var commentsCount: Int
}
