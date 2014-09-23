//
//  Beverage.swift
//  NewHolland
//
//  Created by Jeremy Dyer on 9/21/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

import Foundation

class Beverage {
    
    var degreesPlato:Float! = 0.0
    var beerLogoImageURL:String? = nil
    var beerBottleImageURL:String? = nil
    var beerStyle:String? = nil
    var description:String? = nil
    var grains:String? = nil
    var yeast:String? = nil
    var abv:Float? = nil
    var beerName:String? = nil
    var ibus:Int? = nil
    var firstBrewed:Int? = nil
    var hops:String? = nil
    var pairings:String? = nil
    
    init(jsonData: NSDictionary) {
        self.degreesPlato = (jsonData["Degrees Plato"] as NSString).floatValue
        self.beerLogoImageURL = jsonData["BeerLogoImageURL"] as? String
        self.beerBottleImageURL = jsonData["BeerBottleImageURL"] as? String
        self.beerStyle = jsonData["Beer Style"] as? String
        self.description = jsonData["Description"] as? String
        self.grains = jsonData["Grains"] as? String
        self.yeast = jsonData["Yeast"] as? String
        self.abv = (jsonData["Alcohol by Volume"] as NSString).floatValue
        self.beerName = jsonData["BeerName"] as? String
        self.ibus = (jsonData["IBUs"] as NSString).integerValue
        self.firstBrewed = (jsonData["First Brewed"] as NSString).integerValue
        self.hops = jsonData["Hops"] as? String
        self.pairings = jsonData["Pairings"] as? String
    }
}