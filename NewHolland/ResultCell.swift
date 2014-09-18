//
//  ResultCell.swift
//  NewHolland
//
//  Created by Jeremy Dyer on 9/18/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

import Foundation
import UIKit

class ResultCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        //self.backgroundColor = UIColor.lightGrayColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}