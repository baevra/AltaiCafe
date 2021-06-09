//
//  Query.swift
//  AltaiCafe
//
//  Created by Roman Baev on 28.04.2021.
//

import Foundation

class Query<Dependency> {
    let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }
}
