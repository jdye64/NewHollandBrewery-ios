//
//  BeerView.swift
//  NewHolland
//
//  Created by Jeremy Dyer on 9/23/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

import Foundation
import UIKit

class BeerView: UIView {
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        println("Draw rect was called for \(rect)")
    }
}