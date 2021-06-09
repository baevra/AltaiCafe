//
//  ViewModelable.swift
//  AltaiCafe
//
//  Created by Roman Baev on 14.04.2021.
//

import Foundation
import Combine

protocol ViewModelable {
  associatedtype State
  associatedtype Action

  var state: CurrentValueSubject<State, Never> { get }

  func dispatch(action: Action)
}

