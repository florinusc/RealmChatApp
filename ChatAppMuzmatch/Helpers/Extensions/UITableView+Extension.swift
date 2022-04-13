//
//  UITableView+Extension.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 12.04.2022.
//

import UIKit

extension UITableView {
    
    func registerCell<T: UITableViewCell>(_ type: T.Type) {
        let nib = UINib(nibName: String(describing: T.self), bundle: .main)
        register(nib, forCellReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }
    
}
