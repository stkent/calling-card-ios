//
//  UserTableViewCell.swift
//  Calling Card
//
//  Created by Stuart Kent on 4/30/16.
//  Copyright © 2016 Stuart Kent. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "UserTableViewCell"

    @IBOutlet weak var cellBackgroundView: UIView! {
        didSet {
            cellBackgroundView?.layer.cornerRadius = 8
            cellBackgroundView?.layer.borderColor = UIColor.lightGrayColor().CGColor
            cellBackgroundView?.layer.borderWidth = 4
        }
    }
    
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userEmailAddressLabel: UILabel!
    
    var user: User?
    
    func bindUser(user: User) {
        let photoPixelSize: Int = Int(photoImageView.bounds.width)
        photoImageView.sd_setImageWithURL(user.getPhotoURL(photoPixelSize))
        userNameLabel.text = user.name
        userEmailAddressLabel.text = user.emailAddress
    }
    
}
