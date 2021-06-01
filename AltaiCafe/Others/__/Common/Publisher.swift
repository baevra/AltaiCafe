//
//  Publisher.swift
//  AltaiCafe
//
//  Created by Roman Baev on 15.04.2021.
//

import Foundation
import Combine

extension Publisher where Self.Failure == Never {
    func assignWeakly<Root>(
        to keyPath: ReferenceWritableKeyPath<Root, Self.Output>,
        on object: Root
    ) -> AnyCancellable where Root: AnyObject {
        return sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}

extension Publisher where Self.Output: Collection {
    func mapMany<T>(_ transform: @escaping (Self.Output.Element) -> T) -> Publishers.Map<Self, [T]> {
        return map { $0.map(transform) }
    }
}
