//
//  ResultStore.swift
//  NewHolland
//
//  Created by Jeremy Dyer on 9/19/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

class ResultStore {
    
    //Swift nested singleton model. As the language evolves this may or may not become the best practice. Still too early to tell ...
    class var sharedInstance : ResultStore {
        struct Static {
            static let instance : ResultStore = ResultStore()
        }
        return Static.instance
    }
    
    //Defines notifications that the ResultStore may broadcast throughout the application.
    let NHBSearchBegan: NSString = "NHBSearchBegan"
    let NHBResultsUpdated: NSString = "NHBResultsUpdated"
    
    var beerList:[String] = []
    var searchResults:[SearchResult] = []
    var filteredSearchResults:[SearchResult] = []
    
    let searchURL: String = "http://beerfinder.jeremydyer.me/beerfinder"
    
    //These values are hardcoded for the time being until the filter view is implemented
    var searchBrand = "" //Full text string indicating the drink you are searching for
    let barsOnly = "off" //on means search taverns and bars. off means search only stores where it can be purchased
    let radiusInMiles = "15" //Radius in miles to perform the search for. All request will get the maximum in distance and range will be filtered on this client side
    let milesRadiusMax:Float! = 15.0
    var currentMilesFilterUnder:Float = 15.0
    var searchAddress = "" //Location to search from format "Decatur, GA 30033"
    
    var resultsFiltered:Bool = false
    var currentlyLoadingResults:Bool = false
    
    func locateNearbyBeers(placemark: CLPlacemark) {
        if !self.currentlyLoadingResults {
            self.currentlyLoadingResults = true
            self.notifySearchBegan()
            
            self.searchAddress = String(format: "%@, %@ %@", placemark.locality, placemark.administrativeArea, placemark.postalCode)
            var latitude = String(format: "%.10f", placemark.location.coordinate.latitude)
            var longitude = String(format: "%.10f", placemark.location.coordinate.longitude)
            
            println("Location: \(self.searchAddress) Latitude: \(latitude) Longitude: \(longitude)")
            
            let searchParams:[String:AnyObject] = ["lat": latitude,
                "long": longitude,
                "b": self.searchBrand,
                "t": self.barsOnly,
                "m": self.radiusInMiles,
                "d": self.searchAddress]
            
            Alamofire.request(.GET, self.searchURL, parameters: searchParams)
                .responseJSON { (request, response, json, error) in
                    println(error)
                    println(json)
                    var jsonResult = json as Dictionary<String, NSDictionary>
                    
                    //Clear the past search results.
                    self.searchResults = []
                    self.filteredSearchResults = []
                    self.resultsFiltered = false
                    
                    //Creates the SearchResult objects from the JSON Response
                    var searchResults:NSDictionary = jsonResult["results"] as NSDictionary!
                    
                    var beerLocations:NSArray = searchResults["search_results"] as NSArray!
                    for result in beerLocations {
                        var searchResult:SearchResult = SearchResult(jsonResult:result as NSDictionary)
                        self.searchResults.append(searchResult)
                    }
                    
                    //Populate the beer list
                    var beers:NSArray = searchResults["beer_list"] as NSArray!
                    for beer in beers {
                        self.beerList.append(beer as String)
                    }
                    
                    self.notifyResultsUpdated()
                    self.currentlyLoadingResults = false
            }
        } else {
            println("Already performing search will not make another request until previous response is received")
        }
    }
    
    func notifySearchBegan() {
        NSNotificationCenter.defaultCenter().postNotificationName(self.NHBSearchBegan, object: nil)
    }
    
    func notifyResultsUpdated() {
        NSNotificationCenter.defaultCenter().postNotificationName(self.NHBResultsUpdated, object: nil)
    }
    
    
    func filterResults(filterCriteria:FilterCriteria) {
        
        if !self.currentlyLoadingResults {
            self.resultsFiltered = true
            
            //Clears the existing filered results.
            self.filteredSearchResults = []
            
            //Right now only filtering by miles so narrow the results down to the locations that are within the miles range
            for searchResult in self.searchResults {
                if filterCriteria.passesCriteria(searchResult) {
                    self.filteredSearchResults.append(searchResult)
                }
            }
            
            println("Original Search Results Size -> \(self.searchResults.count) Filtered Search Results Size -> \(self.filteredSearchResults.count)")
            self.notifyResultsUpdated()
        } else {
            println("Results are currently loading so filtering will not occur")
        }
    }
    
    func clearFilteredResults() {
        println("Clearing the filtered results")
        self.filteredSearchResults = []
        self.resultsFiltered = false
    }
}