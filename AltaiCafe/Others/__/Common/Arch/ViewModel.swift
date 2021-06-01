//
//  ViewModel.swift
//  AltaiCafe
//
//  Created by Roman Baev on 14.04.2021.
//

import Foundation
import Combine

final class ViewModel<T: ViewModelable>: ObservableObject {
    @Published var state: T.State

    let viewModel: T
    var subscriptions = Set<AnyCancellable>()

    init(viewModel: T, initialState: T.State) {
        self.viewModel = viewModel
        self.state = initialState

        viewModel.state
            .sink { [weak self] state in
                self?.state = state
            }
            .store(in: &subscriptions)
    }

    func dispatch(action: T.Action) {
        viewModel.dispatch(action: action)
    }
}
