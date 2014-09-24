//
//  BeerView.swift
//  NewHolland
//
//  Created by Jeremy Dyer on 9/24/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

import Foundation
import UIKit

class BeerView: UIView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        println("Init with coder was called")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        println("Init with frame was called!")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        println("Draw rect method was called!")
    }
}