//
//  ChatListViewController.swift
//  GDG_Alibi
//
//  Created by Lee on 2021/07/07.
//

import UIKit

class ChatListViewController: UIViewController {
    
    private var viewModel: ChatListViewModel = ChatListViewModel()
    
    
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var heipButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.viewModel.updateCallBack = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.newChat()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard
            let dest = segue.destination as? ChatViewController,
            let documentID = sender as? String
        else { return }
        
        dest.viewModel = ChatViewModel(documentID: documentID)
    }
    
    
    
    // MARK: - Interface
    
    private func newChat() {
        let new = self.viewModel.chatListData
            .filter { $0.lastMessage == nil }
            .first
        
        guard let documentID = new?.chatDocumentID else { return }
        
        self.performSegue(withIdentifier: "chat", sender: documentID)
    }
    
    
    
    
    
    
    @IBAction func repuestDidTap(_ sender: UIButton) {
        
        
    }
    
    @IBAction func heipDidTap(_ sender: UIButton) {
        
        
    }
    
    @IBAction func helpLongTouch(_ sender: UILongPressGestureRecognizer) {
        
        
    }
}



// MARK: - UITableViewDataSource

extension ChatListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.chatListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell", for: indexPath) as! ChatListTableViewCell
        
        cell.bind(data: self.viewModel.chatListData[indexPath.row])
        
        return cell
    }
}



// MARK: - UITableViewDelegate

extension ChatListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let documentID = self.viewModel.chatListData[indexPath.row].chatDocumentID
        self.performSegue(withIdentifier: "chat", sender: documentID)
    }
}
