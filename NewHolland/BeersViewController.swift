//
//  BeersViewController.swift
//  NewHolland
//
//  Created by Jeremy Dyer on 9/19/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class BeerViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var beerBottleImageView: UIImageView!
    
    var currentIndex:Int = 0
    var beverageStore:BeverageStore = BeverageStore.sharedInstance
    
    override func viewDidLoad() {
        self.displayBeverage(self.beverageStore.beverages[0])
    }
    
    @IBAction func displayNextBeverage(sender: AnyObject) {
        if self.currentIndex >= self.beverageStore.beverages.count - 1 {
            self.currentIndex = 0
        } else {
            self.currentIndex++
        }
        self.displayBeverage(self.beverageStore.beverages[self.currentIndex])
    }
    
    @IBAction func displayPreviousBeverage(sender: AnyObject) {
        if self.currentIndex <= 0 {
            self.currentIndex = self.beverageStore.beverages.count - 1
        } else {
            self.currentIndex--
        }
        self.displayBeverage(self.beverageStore.beverages[self.currentIndex])
    }
    
    func displayBeverage(beverage:Beverage) {
        
        //Loads the logo image
        Alamofire.request(.GET, beverage.beerLogoImageURL!)
            .response { (request, response, data, error) in
                var logoImage = UIImage(data: data as NSData)
                self.logoImageView.image = logoImage
                //self.logoImageView.frame = CGRectMake(self.logoImageView.frame.origin.x, self.logoImageView.frame.origin.y, logoImage.size.width, logoImage.size.height);
                //self.logoImageView.frame = CGRectMake(self.logoImageView.frame.origin.x, self.logoImageView.frame.origin.y, 30, 30);
        }
        
        //Loads the Beer bottle image
        Alamofire.request(.GET, beverage.beerBottleImageURL!)
            .response {(request, response, data, error) in
                var bottleImage = UIImage(data: data as NSData)
                self.beerBottleImageView.image = bottleImage
                //self.beerBottleImageView.frame = CGRectMake(self.beerBottleImageView.frame.origin.x, self.beerBottleImageView.frame.origin.y, bottleImage.size.width, bottleImage.size.height);
        }
    }
}