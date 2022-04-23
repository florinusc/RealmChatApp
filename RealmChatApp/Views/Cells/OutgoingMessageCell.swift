//
//  OutgoingMessageCell.swift
//  RealmChatApp
//
//  Created by Florin Uscatu on 12.04.2022.
//

import UIKit

class OutgoingMessageCell: UITableViewCell {
    @IBOutlet private weak var bubbleView: UIView!
    @IBOutlet private weak var bubbleViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var messageLabel: UILabel!
    
    var message: String? {
        didSet {
            messageLabel.text = message
        }
    }
    
    var isCompact: Bool = false {
        didSet {
            bubbleViewTopConstraint.constant = isCompact ? Constants.cellCompactTopConstraint : Constants.cellRegularTopConstraint
        }
    }
    
    var bubbleWidth: CGFloat {
        return bubbleView.frame.width
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.layer.cornerRadius = Constants.bubbleCornerRadius
    }
}
