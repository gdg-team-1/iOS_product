//
//  ChatMessageTableViewCell.swift
//  GDG_Alibi
//
//  Created by Lee on 2021/07/10.
//

import UIKit

class ChatMessageTableViewCell: UITableViewCell {
    
    let profileImageView = UIImageView()
    let messageLabel = PaddingLabel()
    let photoImageView = UIImageView()
    let dateLabel = UILabel()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setAttribute()
        self.setConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.profileImageView.image = nil
        self.photoImageView.image = nil
        
        print(self.dateLabel.constraints.count)
    }
    
    
    
    func bind(chat: ChatModel) {
        FirebaseUtil.imageDownload(userID: chat.userID) { result in
            DispatchQueue.main.async { [weak self] in
                self?.profileImageView.image = result
            }
        }
        
        switch chat.photoURL {
        case .some(let photoURL):
            FirebaseUtil.imageDownload(imageURL: photoURL) { result in
                DispatchQueue.main.async { [weak self] in
                    self?.photoImageView.image = result
                }
            }
            
        case .none:
            self.messageLabel.text = chat.message
        }
        
        self.dateLabel.text = chat.date.time()
    }
    
    
    
    // MARK: - UI
    
    func setAttribute() {
        self.selectionStyle = .none
        
        self.profileImageView.layer.cornerRadius = 23
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.backgroundColor = UIColor(red: 238 / 255, green: 238 / 255, blue: 238 / 255, alpha: 1)
        
        self.messageLabel.numberOfLines = 0
        self.messageLabel.layer.cornerRadius = 8
        self.messageLabel.layer.masksToBounds = true
        self.messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        self.photoImageView.contentMode = .scaleAspectFill
        self.photoImageView.layer.contents = 8
        self.photoImageView.clipsToBounds = true
        
        self.dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    }
    
    func setConstraint() {
        [self.profileImageView, self.messageLabel, self.photoImageView, self.dateLabel].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            self.profileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.profileImageView.widthAnchor.constraint(equalToConstant: 46),
            self.profileImageView.heightAnchor.constraint(equalToConstant: 46),
            
            self.dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16)
        ])
    }
}



class ChatMyMessageTableViewCell: ChatMessageTableViewCell {
    
    static let identifier = "MyMessage"
    
    override func setConstraint() {
        super.setConstraint()
        
        self.messageLabel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        self.messageLabel.backgroundColor = UIColor(red: 238 / 255, green: 238 / 255, blue: 238 / 255, alpha: 1)
        self.messageLabel.textColor = UIColor(red: 39 / 255, green: 59 / 255, blue: 72 / 255, alpha: 1)
        
        self.photoImageView.isHidden = true
        
        NSLayoutConstraint.activate([
            self.profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            
            self.messageLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.messageLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 16),
            self.messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -16),
            
            self.dateLabel.topAnchor.constraint(equalTo: self.messageLabel.bottomAnchor, constant: 4),
            self.dateLabel.trailingAnchor.constraint(equalTo: self.messageLabel.trailingAnchor)
        ])
    }
}


class ChatMyPhotoTableViewCell: ChatMessageTableViewCell {
    
    static let identifier = "MyPhoto"
    
    override func setConstraint() {
        super.setConstraint()
        
        self.messageLabel.isHidden = true
        
        NSLayoutConstraint.activate([
            self.profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            
            self.photoImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.photoImageView.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 16),
            self.photoImageView.widthAnchor.constraint(equalToConstant: 224),
            self.photoImageView.heightAnchor.constraint(equalToConstant: 152),
            
            self.dateLabel.topAnchor.constraint(equalTo: self.photoImageView.bottomAnchor, constant: 4),
            self.dateLabel.trailingAnchor.constraint(equalTo: self.photoImageView.trailingAnchor)
        ])
    }
}



class ChatOtherMessageTableViewCell: ChatMessageTableViewCell {
    
    static let identifier = "OtherMessage"
    
    override func setConstraint() {
        super.setConstraint()
        
        self.messageLabel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        self.messageLabel.backgroundColor = UIColor(red: 44 / 255, green: 199 / 255, blue: 129 / 255, alpha: 1)
        self.messageLabel.textColor = .white
        
        self.photoImageView.isHidden = true
        
        NSLayoutConstraint.activate([
            self.profileImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            self.messageLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.messageLabel.trailingAnchor.constraint(equalTo: self.profileImageView.leadingAnchor, constant: -16),
            self.messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor, constant: 16),
            
            self.dateLabel.topAnchor.constraint(equalTo: self.messageLabel.bottomAnchor, constant: 4),
            self.dateLabel.leadingAnchor.constraint(equalTo: self.messageLabel.leadingAnchor)
        ])
    }
}


class ChatOtherPhotoTableViewCell: ChatMessageTableViewCell {
    
    static let identifier = "OtherPhoto"
    
    override func setConstraint() {
        super.setConstraint()
        
        self.messageLabel.isHidden = true
        
        NSLayoutConstraint.activate([
            self.profileImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            self.photoImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.photoImageView.trailingAnchor.constraint(equalTo: self.profileImageView.leadingAnchor, constant: -16),
            self.photoImageView.widthAnchor.constraint(equalToConstant: 224),
            self.photoImageView.heightAnchor.constraint(equalToConstant: 152),
            
            self.dateLabel.topAnchor.constraint(equalTo: self.photoImageView.bottomAnchor, constant: 4),
            self.dateLabel.leadingAnchor.constraint(equalTo: self.photoImageView.leadingAnchor)
        ])
    }
}



class PaddingLabel: UILabel {
    private var padding: UIEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    
    override func drawText(in rect: CGRect) {
        let paddingRect = rect.inset(by: padding)
        super.drawText(in: paddingRect)
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
}
