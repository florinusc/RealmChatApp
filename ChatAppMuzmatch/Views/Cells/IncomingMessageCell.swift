//
//  IncomingMessageCell.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 12.04.2022.
//

import UIKit

class IncomingMessageCell: UITableViewCell {
    
    @IBOutlet private weak var bubbleView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    
    var message: String? {
        didSet {
            messageLabel.text = message
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.layer.cornerRadius = 16.0
//        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    
}
