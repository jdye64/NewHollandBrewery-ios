//
//  SearchResult.swift
//  NewHolland
//
//  Created by Jeremy Dyer on 9/18/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

import Foundation

class SearchResult {
    
    var dba:String = ""
    var address:String = ""
    var phone:String = ""
    var milesFromCurrentLocation:Float = 0.0
    
    init() {
        println("Initializing the SearchResult swift object")
    }
    
    init(jsonResult:NSDictionary) {
        self.dba = jsonResult["dba"] as String
        self.address = jsonResult["address"] as String
        self.phone = jsonResult["phone"] as String
        self.milesFromCurrentLocation = (jsonResult["miles"] as NSString).floatValue
    }
    
}