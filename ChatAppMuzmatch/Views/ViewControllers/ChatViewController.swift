//
//  ChatViewController.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 12.04.2022.
//

import UIKit
import Combine
import InputBarAccessoryView

class ChatViewController: UIViewController {
    
    private enum Animation {
        case keyboardWillShow
        case keyboardWillHide
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!

    private let inputBar = CustomInputBar()
    
    override var inputAccessoryView: UIView? {
        return inputBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setUp() {
        setUpTableView()
        setUpNotification()
        inputBar.delegate = self
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerCell(OwnMessageCell.self)
        tableView.registerCell(ForeignMessageCell.self)
        
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        tableView.keyboardDismissMode = .interactive
        
        tableView.estimatedSectionHeaderHeight = .leastNonzeroMagnitude
        tableView.estimatedSectionFooterHeight = .leastNonzeroMagnitude
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
    }

    private func setUpNotification() {
        _ = NotificationCenter.default
            .addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] notification in
                self?.handle(animation: .keyboardWillShow, notification: notification)
            }

        _ = NotificationCenter.default
            .addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] notification in
                self?.handle(animation: .keyboardWillHide, notification: notification)
            }
    }
    
    private func handle(animation: Animation, notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        UIView.animate(withDuration: duration) {
            switch animation {
            case .keyboardWillShow:
                self.tableView.contentInset.top = keyboardFrame.height
            case .keyboardWillHide:
                self.tableView.contentInset.top = 15
            }
            self.view.layoutIfNeeded()
        }
        
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ownCell = tableView.dequeueReusableCell(withIdentifier: "OwnMessageCell", for: indexPath) as! OwnMessageCell
        ownCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        ownCell.message = "Hey, this is a test"
        
        let foreignCell = tableView.dequeueReusableCell(withIdentifier: "ForeignMessageCell", for: indexPath) as! ForeignMessageCell
        foreignCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        foreignCell.message = "Hey, this is a test"
        
        if indexPath.row % 2 == 0 {
            return foreignCell
        }
        
        return ownCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        // Here we can parse for which substrings were autocompleted
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (attributes, range, stop) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }

        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()

        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholder = "Aa"
//                self?.conversation.messages.append(SampleData.Message(user: SampleData.shared.currentUser, text: text))
//                let indexPath = IndexPath(row: (self?.conversation.messages.count ?? 1) - 1, section: 0)
//                self?.tableView.insertRows(at: [indexPath], with: .automatic)
//                self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
}

extension ChatViewController: StoryboardViewController {}
