//
//  Coordinator.swift
//  RealmChatApp
//
//  Created by Florin Uscatu on 23.04.2022.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    func start()
}
