//
//  ForEachBuilder.swift
//  AltaiCafe
//
//  Created by Roman Baev on 28.04.2021.
//

import Foundation
import SwiftUI
import Combine

class ForEachBuilder<Model: Identifiable, ChildBuilder> {
    private(set) var builders: [Model.ID: ChildBuilder] = [:]

    let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func build<Content: View>(items: [Model], content: @escaping (ChildBuilder) -> Content) -> some View {
        let builders = self.builders
        self.builders.removeAll()

        return ForEach(items) { item -> Content in
            guard let builder = builders[item.id] else {
                let builder = self.dependency.buildChild(item)
                self.builders[item.id] = builder
                return content(builder)
            }
            self.builders[item.id] = builder
            return content(builder)
        }
    }
}

extension ForEachBuilder {
    struct Dependency {
        let buildChild: (Model) -> ChildBuilder
    }
}
