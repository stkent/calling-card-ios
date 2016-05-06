//
//  StatusTableViewCell.swift
//  Calling Card
//
//  Created by Stuart Kent on 5/6/16.
//  Copyright © 2016 Stuart Kent. All rights reserved.
//

import UIKit

class StatusTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "StatusTableViewCell"
    
    @IBOutlet private weak var label: UILabel!
    
    var statusText: String? {
        didSet {
            label.text = statusText
        }
    }
    
}
