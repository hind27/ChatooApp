//
//  ChatCell.swift
//  ChatooApp
//
//  Created by hind on 3/18/19.
//  Copyright © 2019 hind. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    enum bubbleType {
        case incoming
        case outcoming
    }
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var chatStack: UIStackView!
    
    @IBOutlet weak var ChatTextBubble: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ChatTextBubble.layer.cornerRadius = 6
    }
    func SetMessageData(message : Message)  {
        userNameLabel.text = message.senderName
        messageTextView.text = message.messageText
    }
    
    func setBubbleType(type : bubbleType) {
        if (type == .incoming){
            chatStack.alignment = .leading
            ChatTextBubble.backgroundColor = #colorLiteral(red: 0.08516963172, green: 0.589387812, blue: 0.6207581882, alpha: 0.4591181507)
            messageTextView.textColor = .white
            
        }else if (type == .outcoming){
            chatStack.alignment = .trailing
            ChatTextBubble.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            messageTextView.textColor = .black
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
}
