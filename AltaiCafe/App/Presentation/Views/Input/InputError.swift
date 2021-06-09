//
//  InputError.swift
//  AltaiCafe
//
//  Created by Roman Baev on 28.05.2021.
//

import Foundation
import SwiftUI

struct InputError: View {
  let message: String

  init(_ message: String) {
    self.message = message
  }
  
  var body: some View {
    Text(message)
      .foregroundColor(.red)
  }
}
