//
//  UserTableViewCell.swift
//  Calling Card
//
//  Created by Stuart Kent on 4/30/16.
//  Copyright © 2016 Stuart Kent. All rights reserved.
//

import UIKit

enum BorderColor {
    case Grey
    case Green
    case Red
    
    var asUIColor: UIColor {
        switch self {
        case .Grey:
            return UIColor.lightGrayColor()
        case .Green:
            return UIColor(red: 113.0/255.0, green: 217.0/255.0, blue: 114.0/255.0, alpha: 1)
        case.Red:
            return UIColor(red: 1, green: 127.0/255.0, blue: 128.0/255.0, alpha: 1)
        }
    }
}

class UserTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "UserTableViewCell"

    @IBOutlet weak var cellBackgroundView: UIView! {
        didSet {
            cellBackgroundView?.layer.cornerRadius = 8
            cellBackgroundView?.layer.borderWidth = 4
            setBorderColor(.Grey)
        }
    }
    
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userEmailAddressLabel: UILabel!
    
    var user: User?
    
    func bindUser(user: User) {
        userNameLabel.text = user.name
        userEmailAddressLabel.text = user.emailAddress
        
        if let photoUrlString = user.photoUrlString {
            photoImageView.sd_setImageWithURL(NSURL(string: photoUrlString))
        }
    }
    
    let publishingBorderColor = UIColor(red: 113.0/255.0, green: 217.0/255.0, blue: 114.0/255.0, alpha: 1)
    
    let notPublishingBorderColor = UIColor(red: 1, green: 127.0/255.0, blue: 128.0/255.0, alpha: 1)
    
    func setBorderColor(borderColor: BorderColor) {
        let borderUIColor = borderColor.asUIColor
        
        let backgroundColor = borderUIColor.colorWithAlphaComponent(0.4)
        
        cellBackgroundView?.layer.borderColor = borderUIColor.CGColor
        cellBackgroundView.backgroundColor = backgroundColor
    }
    
}
