//
//  PublishedUserTableViewCell.swift
//  Calling Card
//
//  Created by Stuart Kent on 4/30/16.
//  Copyright © 2016 Stuart Kent. All rights reserved.
//

import UIKit

class PublishedUserTableViewCell: UserTableViewCell {
    
    let publishingBorderColor = UIColor(red: 113.0/255.0, green: 217.0/255.0, blue: 114.0/255.0, alpha: 1)
    
    let notPublishingBorderColor = UIColor(red: 1, green: 127.0/255.0, blue: 128.0/255.0, alpha: 1)
    
    static let subclassReuseIdentifier = "PublishedUserTableViewCell"
    
    var publishing: Bool = false {
        didSet {
            let borderColor = publishing ? publishingBorderColor : notPublishingBorderColor
            
            let backgroundColor = borderColor.colorWithAlphaComponent(0.4)
            
            cellBackgroundView?.layer.borderColor = borderColor.CGColor
            cellBackgroundView.backgroundColor = backgroundColor
        }
    }
    
}
