//
//  ChatController.swift
//  clerkie-challenge
//
//  Created by Shouvik Paul on 11/9/18.
//

import UIKit

class ChatController: UIViewController {
    
    var user: ChatUser!
    var messages: [Message] = []
    var placeHolderText = "Enter message.."
    var ogTextViewHeight: CGFloat = 0.0
    var ogBottomViewHeight: CGFloat = 0.0
    var textViewLineCount: Int = 0
    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var chatName: UILabel!
    
    private var keyboardVisible: Bool = false
    
    private var keyboardWillShowObserver = false {
        didSet {
            if keyboardWillShowObserver {
                NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            } else {
                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            }
        }
    }
    
    private var keyboardWillHideObserver = false {
        didSet {
            if keyboardWillHideObserver {
                NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            } else {
                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        print("chat controller view did load")
        
        keyboardWillHideObserver = true
        keyboardWillShowObserver = true
        setupTableView()
        setupTextView()
        
        self.addDismissScreenEdgePanGesture()
        
        backButton.setTitle("\u{3008}", for: .normal)
        chatName.text = user.name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        keyboardWillShowObserver = false
        keyboardWillHideObserver = false
    }
    
    @IBAction func backTap(_ sender: Any) {
        dismissFromLeft()
    }
    
    @IBAction func sendTap(_ sender: Any) {
        print("send tap")
        sendMessage()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("keyboard height:", keyboardSize.height)
            self.bottomViewBottom.constant = keyboardSize.height
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
        }
        keyboardVisible = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print("on keyboard hide")
        bottomViewBottom.constant = 0
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        keyboardVisible = false
    }
    
    func message(at: Int) -> Message? {
        if at >= 0 && at < messages.count {
            return messages[at]
        }
        return nil
    }
    
    func showHideGoButton(_ show: Bool) {
        if show {
            if sendButton.isHidden {
                sendButton.isHidden = false
                UIView.animate(withDuration: 0.15) {
                    self.sendButton.alpha = 1.0
                }
            }
        } else {
            if !sendButton.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    self.sendButton.alpha = 0.0
                }) { _ in
                    self.sendButton.isHidden = true
                }
            }
        }
    }
    
    func sendMessage() {
        if textView.text != nil {
            messages.append(Message(sent: true, image: nil, text: textView.text))
            reloadData()
        }
        showPlaceHolderText()
        showHideGoButton(false)
        
        if message(at: messages.count - 2) == nil || message(at: messages.count - 2)!.sent {
            sendFakeMessage("Lebroon Jaaams")
        }
    }
    
    func sendFakeMessage(_ text: String) {
        messages.append(Message(sent: false, image: nil, text: text))
        reloadData()
    }
}

extension ChatController: UITextViewDelegate {
    
    func setupTextView() {
        textView.delegate = self
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        
        textView.contentInset = UIEdgeInsets(top: 0.0, left: 4.0, bottom: 0.0, right: 40.0)
        ogTextViewHeight = textViewHeight.constant
        ogBottomViewHeight = bottomViewHeight.constant
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolderText {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        scrollToBottom()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("text view did end editing")
        if textView.text.isEmpty {
            showPlaceHolderText()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        showHideGoButton(textView.text != "")
        if self.textView.contentSize.height > textViewHeight.constant, textViewLineCount < 4 {
            bottomViewHeight.constant += self.textView.contentSize.height - textViewHeight.constant
            textViewHeight.constant = self.textView.contentSize.height
            textViewLineCount += 1
        } else if self.textView.contentSize.height < textViewHeight.constant {
            bottomViewHeight.constant -= textViewHeight.constant - self.textView.contentSize.height
            textViewHeight.constant = self.textView.contentSize.height
            textViewLineCount -= 1
        }
    }
    
    func showPlaceHolderText() {
        bottomViewHeight.constant = ogBottomViewHeight
        textViewHeight.constant = ogTextViewHeight
        if textView.isFirstResponder {
            textView.text = nil
            return
        }
        textView.text = placeHolderText
        textView.textColor = UIColor.lightGray
    }
}

extension ChatController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        messagesTableView.delegate = self
        messagesTableView.dataSource = self// chats as? UITableViewDataSource
        
        messagesTableView.rowHeight = UITableView.automaticDimension
        messagesTableView.estimatedRowHeight = 31.5
        messagesTableView.allowsSelection = false
        reloadData()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.messagesTableView.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollToBottom()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        
        guard let m = message(at: indexPath.row) else { return cell }
        
        var textLabel: UITextView
        if m.sent {
            textLabel = cell.sentMessageText
            cell.receivedMessageText.isHidden = true
            if let receivedImage = cell.receivedImage {
                receivedImage.removeFromSuperview()
            }
        } else {
            textLabel = cell.receivedMessageText
            cell.sentMessageText.isHidden = true
            if let receivedImage = cell.receivedImage, let b = message(at: indexPath.row - 1)?.sent, !b {
                receivedImage.removeFromSuperview()
            } else {
                cell.receivedImage.image = user.image
            }
        }
        textLabel.isScrollEnabled = false
        textLabel.isEditable = false
        textLabel.text = m.text
        textLabel.textContainerInset = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
        textLabel.backgroundColor = (m.sent) ? UIColor.clerkieRed : UIColor.clerkieLightGray
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            textLabel.sizeToFit()
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected chat user:", messages[indexPath.row])
    }
    
    func scrollToBottom() {
        var y: CGFloat = 0.0
        if messagesTableView.contentSize.height > messagesTableView.bounds.size.height {
            y = messagesTableView.contentSize.height - messagesTableView.bounds.size.height
        }
        print("scroll to bottom. y:", y)
        messagesTableView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
    }
}

extension ChatController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0, keyboardVisible {
            self.view.endEditing(true)
        }
    }
}

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var receivedImage: UIImageView!
    @IBOutlet weak var receivedMessageText: UITextView!
    @IBOutlet weak var sentMessageText: UITextView!
    
}
