//
//  OutgoingMessageCell.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 12.04.2022.
//

import UIKit

class OutgoingMessageCell: UITableViewCell {
    
    @IBOutlet private weak var bubbleView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    
    var message: String? {
        didSet {
            messageLabel.text = message
        }
    }
    
    var bubbleWidth: CGFloat {
        return bubbleView.frame.width
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.layer.cornerRadius = 16.0
    }
    
}
