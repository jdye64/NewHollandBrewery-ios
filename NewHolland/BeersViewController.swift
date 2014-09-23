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
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    //Outlets for the Beer Description View
    @IBOutlet weak var beerBottleUIImage: UIImageView!
    @IBOutlet weak var beerDescriptionView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var beerStyleView: UIView!
    @IBOutlet weak var beerStyleLabel: UILabel!
    @IBOutlet weak var abvView: UIView!
    @IBOutlet weak var abvLabel: UILabel!
    @IBOutlet weak var degreesPlatoView: UIView!
    @IBOutlet weak var degreesPlatoLabel: UILabel!
    @IBOutlet weak var ibusView: UIView!
    @IBOutlet weak var ibusLabel: UILabel!
    @IBOutlet weak var grainsView: UIView!
    @IBOutlet weak var grainsLabel: UILabel!
    @IBOutlet weak var hopsView: UIView!
    @IBOutlet weak var hopsLabel: UILabel!
    @IBOutlet weak var yeastView: UIView!
    @IBOutlet weak var yeastLabel: UILabel!
    
    @IBOutlet weak var locateNearbyBeersButton: UIButton!
    
    let subviewAlpha:CGFloat = 0.6
    var currentIndex:Int = 0
    var beverageStore:BeverageStore = BeverageStore.sharedInstance
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        //Registers the UITableViewController to listen for updates to the datasource from filtering, loading results, etc
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadStarted:", name: BeverageStore.sharedInstance.NHBBeginLoadingBeers, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadCompleted:", name: BeverageStore.sharedInstance.NHBBeersLoaded, object: nil)
        
        //Set up the view
        self.backgroundImageView.image = UIImage(named:"back-lg")
        
        //Sets the transparency for all of the sub views in the custom view
        self.beerDescriptionView.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(subviewAlpha)
        self.beerStyleView.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(subviewAlpha)
        self.abvView.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(subviewAlpha)
        self.degreesPlatoView.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(subviewAlpha)
        self.ibusView.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(subviewAlpha)
        self.grainsView.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(subviewAlpha)
        self.hopsView.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(subviewAlpha)
        self.yeastView.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(subviewAlpha)
        
        //Loads all of the beers from the server
        self.beverageStore.loadAllBeverages()
    }
    
    func loadStarted(notification: NSNotification) {
        println("Loading beers has began")
    }
    
    func loadCompleted(notification: NSNotification) {
        println("Done loading beers from web service")
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
        
//        //Loads the logo image
//        Alamofire.request(.GET, beverage.beerLogoImageURL!)
//            .response { (request, response, data, error) in
//                var logoImage = UIImage(data: data as NSData)
//                self.logoImageView.image = logoImage
//        }
        
        //Loads the Beer bottle image
        Alamofire.request(.GET, beverage.beerBottleImageURL!)
            .response {(request, response, data, error) in
                var bottleImage = UIImage(data: data as NSData)
                self.beerBottleUIImage.image = bottleImage
        }
        
        self.descriptionLabel.text? = beverage.description!
        
        //Set up the Beer Style View
        self.beerStyleLabel.text? = beverage.beerStyle!
        self.abvLabel.text? = NSString(format: "%.2f", beverage.abv!) + " %"
        
        self.ibusLabel.text? = NSString(format: "%d", beverage.ibus!)
        self.degreesPlatoLabel.text? = NSString(format: "%.2f", beverage.degreesPlato!)
        self.grainsLabel.text? = beverage.grains!
        self.hopsLabel.text? = beverage.hops!
        self.yeastLabel.text? = beverage.yeast!
        
        self.locateNearbyBeersButton.titleLabel?.text? = "Locate nearby " + beverage.beerName!
    }
    
    
    @IBAction func locateNearbyBeers(sender: AnyObject) {
        println("Not yet implemented! Locate nearby beers")
    }
    
    
}