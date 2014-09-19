//
//  BeersViewController.swift
//  NewHolland
//
//  Created by Jeremy Dyer on 9/19/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

import Foundation
import UIKit

class BeerViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var beerBottleImageView: UIImageView!
    
    override func viewDidLoad() {
        var logoUrl = NSURL.URLWithString("http://newhollandbrew.com/wp-content/uploads/NewHollandBC_2013_BlackHatter_Wordmark-copy.png")
        var logoData = NSData(contentsOfURL : logoUrl)
        var logoImage = UIImage(data : logoData)
        logoImageView.image = logoImage
        println("Logo Image Width: \(logoImage.size.width) Logo Image Height: \(logoImage.size.height)")
        logoImageView.frame = CGRectMake(logoImageView.frame.origin.x, logoImageView.frame.origin.y,
            logoImage.size.width, logoImage.size.height);
        
        var bottleImageUrl = NSURL.URLWithString("http://newhollandbrew.com/wp-content/uploads/product-blackhatter-sm.png")
        var bottleImageData = NSData(contentsOfURL : bottleImageUrl)
        var bottleImage = UIImage(data : bottleImageData)
        beerBottleImageView.image = bottleImage
        println("Bottle Image Width: \(bottleImage.size.width) Bottle Image Height: \(bottleImage.size.height)")
        beerBottleImageView.frame = CGRectMake(beerBottleImageView.frame.origin.x, beerBottleImageView.frame.origin.y,
            bottleImage.size.width, bottleImage.size.height);
    }
}