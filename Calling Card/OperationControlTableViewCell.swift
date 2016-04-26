//
//  OperationControlTableViewCell.swift
//  Calling Card
//
//  Created by Stuart Kent on 4/29/16.
//  Copyright © 2016 Stuart Kent. All rights reserved.
//

import UIKit

class OperationControlTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "OperationControlTableViewCell"
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var control: UISwitch!
    
    @IBAction func controlTapIntercepted(sender: UIButton) {
        controlDelegate?.controlToggled(operation!)
    }
    
    weak var controlDelegate: OperationControlTableViewCellDelegate?
    
    var operation: NearbyAPIOperation? {
        didSet {
            label.text = operation?.rawValue
        }
    }
    
    var controlOn: Bool = false {
        didSet {
            control.on = controlOn
        }
    }

}

protocol OperationControlTableViewCellDelegate: class {

    func controlToggled(operation: NearbyAPIOperation)

}
