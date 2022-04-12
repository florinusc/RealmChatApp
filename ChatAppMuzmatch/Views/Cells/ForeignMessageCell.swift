//
//  ForeignMessageCell.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 12.04.2022.
//

import UIKit

class ForeignMessageCell: UITableViewCell {
    
    @IBOutlet private weak var bubbleView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    
    var message: String? {
        didSet {
            messageLabel.text = message
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.layer.cornerRadius = 8.0
    }
    
    
}
