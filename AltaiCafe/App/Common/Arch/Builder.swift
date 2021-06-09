//
//  Builder.swift
//  AltaiCafe
//
//  Created by Roman Baev on 28.04.2021.
//

import Foundation

class Builder<Dependency> {
    let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }
}
