//
//  InputGroup.swift
//  AltaiCafe
//
//  Created by Roman Baev on 28.05.2021.
//

import Foundation
import SwiftUI

struct InputGroup<Content: View>: View {
  let content: () -> Content
  
  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      content()
    }
  }
}
