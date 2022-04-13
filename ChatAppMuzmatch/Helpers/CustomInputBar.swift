//
//  CustomInputBar.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 12.04.2022.
//

import UIKit
import InputBarAccessoryView

final class CustomInputBar: InputBarAccessoryView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        if #available(iOS 13, *) {
            inputTextView.layer.borderColor = UIColor.systemGray2.cgColor
        } else {
            inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        }
        inputTextView.layer.borderWidth = 1.0
        inputTextView.layer.cornerRadius = 16.0
        inputTextView.layer.masksToBounds = true
        inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        setRightStackViewWidthConstant(to: 38, animated: false)
        setStackViewItems([sendButton, InputBarButtonItem.fixedSpace(2)], forStack: .right, animated: false)
        sendButton.imageView?.backgroundColor = tintColor
        sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        sendButton.image = UIImage(named: "arrow_up")
        sendButton.title = nil
        sendButton.imageView?.layer.cornerRadius = 16
        sendButton.backgroundColor = .clear
        middleContentViewPadding.right = -38
        separatorLine.isHidden = true
        isTranslucent = true
    }
    
    func addView(yDistance: CGFloat, _ completion: @escaping () -> Void) {
        let frame = convert(inputTextView.frame, from: contentView)
        let animatingView = UIView(frame: frame)
        animatingView.backgroundColor = .systemPink
        animatingView.layer.cornerRadius = 16.0
        animatingView.alpha = 0.2
        
        let textLabel = UILabel(frame: CGRect(x: 20, y: 7, width: frame.width - 44.0, height: frame.height - 16))
        textLabel.text = inputTextView.text
        textLabel.font = inputTextView.font
        textLabel.numberOfLines = 0
        
        animatingView.addSubview(textLabel)
        
        addSubview(animatingView)
        
        textLabel.sizeToFit()
        
        UIView.animate(withDuration: 1, delay: 0) {
            textLabel.frame = CGRect(x: 10, y: 7, width: textLabel.frame.width, height: textLabel.frame.height)
            let newFrame = CGRect(x: self.frame.width - textLabel.frame.width - 40,
                                  y: animatingView.frame.minY - yDistance,
                                  width: textLabel.frame.width + 30,
                                  height: animatingView.frame.height )
            animatingView.frame = newFrame
            animatingView.alpha = 0.9
            textLabel.textColor = .white
        } completion: { _ in
            animatingView.removeFromSuperview()
            completion()
        }

    }
    
}

extension UIView{
    var globalPoint :CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }

    var globalFrame :CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
}
