//
//  ChatListTableViewCell.swift
//  GDG_Alibi
//
//  Created by Lee on 2021/07/07.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    
    
    func bind(data: ChatListModel) {
        self.profileImageView.layer.cornerRadius = 52 / 2
        
        self.titleLabel.text = data.helpUser
        self.dateLabel.text = data.date.monthDay()
        self.subLabel.text = data.category
    }
}
