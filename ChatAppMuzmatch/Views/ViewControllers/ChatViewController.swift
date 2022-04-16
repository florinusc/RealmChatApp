//
//  ChatViewController.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 12.04.2022.
//

import UIKit
import Combine
import InputBarAccessoryView

typealias ChatDataSource = UITableViewDiffableDataSource<MessageSection, Message>
typealias ChatSnapshot = NSDiffableDataSourceSnapshot<MessageSection, Message>

class ChatViewController: UIViewController, ViewModelBased, StoryboardViewController {
    
    private enum Animation {
        case keyboardWillShow
        case keyboardWillHide
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!

    private let inputBar = CustomInputBar()
    
    var viewModel: ChatViewModel!
    
    private var lastIndexPath: IndexPath? {
        guard let lastSectionIndex = self.viewModel.lastSectionIndex,
              let lastMessageIndex = self.viewModel.lastMessageIndex else {
            return nil
        }
        return IndexPath(row: lastMessageIndex, section: lastSectionIndex)
    }
    
    private var isAnimating = false
    
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
        title = viewModel.chatName
        setUpTableView()
        setUpNotification()
        viewModel.dataSource = createDataSource()
        inputBar.delegate = self
        scrollToBottom()
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        
        tableView.registerCell(OutgoingMessageCell.self)
        tableView.registerCell(IncomingMessageCell.self)
        
        tableView.keyboardDismissMode = .interactive
        
        tableView.estimatedSectionFooterHeight = .leastNonzeroMagnitude
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
    }
    
    private func createDataSource() -> ChatDataSource {
        let dataSource = ChatDataSource(tableView: tableView) { [weak self] (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
            guard let self = self else { return nil }
            
            let message = itemIdentifier
            
            let isCompact = self.viewModel.isCompactMessage(at: indexPath)
            
            if !self.viewModel.isOwn(message: message) {
                let incomingMessageCell: IncomingMessageCell = tableView.dequeueCell(for: indexPath)
                incomingMessageCell.message = message.content
                incomingMessageCell.isCompact = isCompact
                return incomingMessageCell
            }
            
            let outgoingMessageCell: OutgoingMessageCell = tableView.dequeueCell(for: indexPath)
            outgoingMessageCell.message = message.content
            outgoingMessageCell.isCompact = isCompact
            
            let lastSection = self.viewModel.lastSection == self.viewModel.section(for: message)
            let lastMessage = self.viewModel.lastMessage == message
            
            if lastSection && lastMessage && self.isAnimating {
                outgoingMessageCell.isHidden = true
            } else {
                outgoingMessageCell.isHidden = false
            }
            
            return outgoingMessageCell
        }
        return dataSource
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
        else {
            return
        }
        
        UIView.animate(withDuration: duration) {
            switch animation {
            case .keyboardWillShow:
                self.tableViewBottomConstraint.constant = keyboardFrame.height
            case .keyboardWillHide:
                self.tableViewBottomConstraint.constant = 15
            }
            self.scrollToBottom()
            self.view.layoutIfNeeded()
        }
    }
    
    private func scrollToBottom() {
        DispatchQueue.main.async {
            guard let lastIndexPath = self.lastIndexPath else { return }
            self.tableView.scrollToRow(at: lastIndexPath, at: .top, animated: false)
        }
    }
    
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = viewModel.titleForHeader(in: section)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 10)
        return label
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        isAnimating = true
        inputBar.sendButton.isEnabled = false
        self.viewModel.addMessage(inputBar.inputTextView.text) {
            UIView.animate(withDuration: 0.15) {
                self.scrollToBottom()
            } completion: { _ in
                guard
                    let customInputBar = inputBar as? CustomInputBar,
                    let lastIndexPath = self.lastIndexPath,
                    let lastCell = self.tableView.cellForRow(at: lastIndexPath) as? OutgoingMessageCell
                else {
                    return
                }
                let lastCellGlobalPoint = lastCell.originOnWindow
                let topPadding: CGFloat = self.viewModel.isCompactMessage(at: lastIndexPath) ? Constants.cellCompactTopConstraint : Constants.cellRegularTopConstraint
                customInputBar.addView(center: lastCellGlobalPoint, width: lastCell.bubbleWidth, topPadding: topPadding) {
                    lastCell.isHidden = false
                    self.isAnimating = false
                }
            }
        }
    }
    
}
