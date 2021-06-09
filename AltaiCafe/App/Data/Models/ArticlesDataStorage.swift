//
//  ArticlesDataStorage.swift
//  AltaiCafe
//
//  Created by Roman Baev on 28.04.2021.
//

import Foundation
import Combine

class ArticlesDataStorage {
  private var viewsCount: [ID: Int] = [:]
  private var commentsCount: [ID: Int] = [:]
  
  func getViewsCount(id: ID) -> Int? {
    viewsCount[id]
  }
  
  func getViewsCount(id: ID, default range: Range<Int>) -> Int {
    guard let count = viewsCount[id] else {
      let randomCount = Int.random(in: range)
      viewsCount[id] = randomCount
      return randomCount
    }
    return count
  }
  
  func setViewsCount(id: ID, count: Int) {
    viewsCount[id] = count
  }
  
  func getCommentsCount(id: ID) -> Int? {
    return commentsCount[id]
  }
  
  func getCommentsCount(id: ID, default range: Range<Int>) -> Int {
    guard let count = commentsCount[id] else {
      let randomCount = Int.random(in: range)
      commentsCount[id] = randomCount
      return randomCount
    }
    return count
  }
  
  func setCommentsCount(id: ID, count: Int) {
    commentsCount[id] = count
  }
}

extension ArticlesDataStorage {
  static let shared = ArticlesDataStorage()
}
