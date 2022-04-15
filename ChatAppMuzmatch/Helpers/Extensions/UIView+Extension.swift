//
//  UIView+Extension.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 14.04.2022.
//

import UIKit

extension UIView {
    
    var globalPoint :CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }

    var globalFrame :CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
    
    var originOnWindow: CGPoint {
        return convert(CGPoint.zero, to: nil)
    }
    
}
