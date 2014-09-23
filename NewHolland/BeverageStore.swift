//
//  BeverageStore.swift
//  NewHolland
//
//  Created by Jeremy Dyer on 9/21/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

import Foundation
import Alamofire

class BeverageStore {
    
    //Swift nested singleton model. As the language evolves this may or may not become the best practice. Still too early to tell ...
    class var sharedInstance : BeverageStore {
        struct Static {
            static let instance : BeverageStore = BeverageStore()
        }
        return Static.instance
    }
    
    //Defines notifications that the ResultStore may broadcast throughout the application.
    let NHBBeginLoadingBeers: NSString = "NHBBeginLoadingBeers"
    let NHBBeersLoaded: NSString = "NHBBeersLoaded"
    
    let beersURL: String = "http://beerfinder.jeremydyer.me/beers"
    var beverages:[Beverage] = []
    
    private init() {
        //self.loadAllBeverages()
    }
    

    func loadAllBeverages() {
        self.notifyLoadBegin()
        
        Alamofire.request(.GET, self.beersURL)
            .responseJSON { (request, response, json, error) in
                println(error)
                
                self.beverages = []
                var jsonResult = json as Dictionary<String, NSArray>
                
                var beers = jsonResult["beers"] as NSArray!
                for beer in beers {
                    self.beverages.append(Beverage(jsonData:beer as NSDictionary))
                }
                
                println("Loaded \(self.beverages.count) beers into the local beer store")
                
                //Let the application know that the data is loaded and ready to be used now
                self.notifyLoadComplete()
        }
    
    }
    
    func notifyLoadBegin() {
        NSNotificationCenter.defaultCenter().postNotificationName(self.NHBBeginLoadingBeers, object: nil)
    }
    
    func notifyLoadComplete() {
        NSNotificationCenter.defaultCenter().postNotificationName(self.NHBBeersLoaded, object: nil)
    }

}