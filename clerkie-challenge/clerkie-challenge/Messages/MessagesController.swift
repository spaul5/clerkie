//
//  MessagesController.swift
//  clerkie-challenge
//
//  Created by Shouvik Paul on 11/9/18.
//

import UIKit

class MessagesController: UIViewController {
    
    @IBOutlet weak var chatsTableView: UITableView!
    
    var chats: [ChatUser] = []
    var selectedCell: Int? = nil
    
    override func viewDidLoad() {
        print("messages controller view did load")
        
        chats = [ChatUser(name: "Shouvik Paul", image: UIImage(imageLiteralResourceName: "shouvik")), ChatUser(name: "Lebroon Jaames Kid", image: UIImage(imageLiteralResourceName: "lebronJamesKid"))]
        
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let i =  selectedCell {
            chatsTableView.deselectRow(at: IndexPath(row: i, section: 0), animated: true)
            selectedCell = nil
        }
    }
    
    @IBAction func logoutTap(_ sender: Any) {
        Utilities.shared.logout()
    }
    
    @IBAction func moreTap(_ sender: Any) {
        print("more tap")
    }
    
    func chatUser(at: Int) -> ChatUser? {
        if at >= 0 && at < chats.count {
            return chats[at]
        }
        return nil
    }
}

extension MessagesController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        chatsTableView.delegate = self
        chatsTableView.dataSource = self// chats as? UITableViewDataSource
        
        reloadData()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.chatsTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatUserCell", for: indexPath) as! ChatUserCell
        
        guard let u = chatUser(at: indexPath.row) else { return cell }
        
        cell.chatImage.image = u.image
        cell.name.text = u.name
        
        return cell
    }
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let u = chatUser(at: indexPath.row) else { return }
        selectedCell = indexPath.row
        
        print("selected chat user:", u.name)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chat = storyboard.instantiateViewController(withIdentifier: "chatController")
        let chatVC = chat as! ChatController
        chatVC.user = u
        self.presentFromRight(chatVC)
    }
    
}

class ChatUserCell: UITableViewCell {
    
    @IBOutlet weak var chatImage: UIImageView!
    @IBOutlet weak var name: UILabel!
}
