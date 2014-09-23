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
    
    let beersURL: String = "http://beerfinder.jeremydyer.me/beers"
    var beverages:[Beverage] = []
    
    private init() {
        self.loadAllBeverages()
    }
    

    func loadAllBeverages() {
        
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
        }
    
    }

}