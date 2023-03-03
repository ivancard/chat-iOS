//
//  MessageTableViewCell.swift
//  Flash Chat iOS13
//
//  Created by ivan cardenas on 02/03/2023.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBubble.layer.cornerRadius = 12
        messageBubble.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
