//
//  ViewModel.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 15.04.2022.
//

import UIKit

protocol ViewModel {}

protocol ViewModelBased: AnyObject {
    associatedtype ViewModelType: ViewModel
    var viewModel: ViewModelType! { get set }
}

extension ViewModelBased where Self: StoryboardViewController & UIViewController {
    static func getInstance(with viewModel: ViewModelType) -> Self {
        let viewController = Self.getInstance()
        viewController.viewModel = viewModel
        return viewController
    }
}
