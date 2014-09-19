//
//  FilterCriteria.swift
//  NewHolland
//
//  Created by Jeremy Dyer on 9/19/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

import Foundation

class FilterCriteria: NSObject {
    
    override init() {
        super.init()
    }
    
    var maxMiles:Float? = nil
    var brand:String? = nil
    
    //Examines a SearchResult to see if it passes the defined filter criteria
    func passesCriteria(searchResult:SearchResult) -> Bool {
        
        //Filters SearchResults by distance
        if self.maxMiles != nil {
            if searchResult.milesFromCurrentLocation > self.maxMiles {
                return false
            }
        }
        
        //Filters SearchResults by brands available
        if self.brand != nil && self.brand != "any product"{
            var matchFound:Bool = false
            for br in searchResult.brands {
                if br == self.brand {
                    matchFound = true
                    break
                }
            }
            
            if !matchFound {
                return false
            }
        }
        
        return true
    }
}