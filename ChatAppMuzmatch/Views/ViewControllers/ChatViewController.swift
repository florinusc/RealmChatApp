//
//  ChatViewController.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 12.04.2022.
//

import UIKit
import Combine
import InputBarAccessoryView

enum MessageSection {
    case main
}

typealias DataSource = UITableViewDiffableDataSource<MessageSection, Message>
typealias Snapshot = NSDiffableDataSourceSnapshot<MessageSection, Message>

class ChatViewController: UIViewController {
    
    private enum Animation {
        case keyboardWillShow
        case keyboardWillHide
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!

    private let inputBar = CustomInputBar()
    
    private let viewModel = ChatViewModel()
    
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
        setUpTableView()
        setUpNotification()
        viewModel.dataSource = createDataSource()
        inputBar.delegate = self
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        
        tableView.registerCell(OutgoingMessageCell.self)
        tableView.registerCell(IncomingMessageCell.self)
        
        tableView.keyboardDismissMode = .interactive
        
        tableView.estimatedSectionHeaderHeight = .leastNonzeroMagnitude
        tableView.estimatedSectionFooterHeight = .leastNonzeroMagnitude
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
    }
    
    private func createDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView) { [weak self] (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
            guard let self = self else { return nil }
            let message = self.viewModel.messages[indexPath.row]
            
            if message.sender.name != "Me" {
                let incomingMessageCell: IncomingMessageCell = tableView.dequeueCell(for: indexPath)
                incomingMessageCell.message = message.content
                return incomingMessageCell
            }
            
            let outgoingMessageCell: OutgoingMessageCell = tableView.dequeueCell(for: indexPath)
            outgoingMessageCell.message = message.content
            
            if indexPath.row == (self.viewModel.messages.count - 1) && self.isAnimating {
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
        else { return }
        
        UIView.animate(withDuration: duration) {
            switch animation {
            case .keyboardWillShow:
                self.tableViewBottomConstraint.constant = keyboardFrame.height
            case .keyboardWillHide:
                self.tableViewBottomConstraint.constant = 15
            }
            self.view.layoutIfNeeded()
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
        return .leastNonzeroMagnitude
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        isAnimating = true
        self.viewModel.addMessage(inputBar.inputTextView.text) {
            UIView.animate(withDuration: 0.15) {
                self.tableView.scrollToRow(at: IndexPath(row: self.viewModel.messages.count - 1, section: 0), at: .bottom, animated: false)
            } completion: { _ in
                guard
                    let customInputBar = inputBar as? CustomInputBar,
                    let lastCell = self.tableView.cellForRow(at: IndexPath(row: self.viewModel.messages.count - 1, section: 0)) as? OutgoingMessageCell
                else {
                    return
                }
                let lastCellGlobalPoint = lastCell.originOnWindow
                customInputBar.addView(center: lastCellGlobalPoint, width: lastCell.bubbleWidth) {
                    lastCell.isHidden = false
                    self.isAnimating = false
                }
            }
        }
    }
    
}

extension ChatViewController: StoryboardViewController {}
