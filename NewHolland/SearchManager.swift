//
//  SearchManager.swift
//  NewHolland
//
//  Created by Jeremy Dyer on 9/19/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

import Foundation
import CoreLocation

class SearchManager: NSObject, CLLocationManagerDelegate {
    
    //Swift nested singleton model. As the language evolves this may or may not become the best practice. Still too early to tell ...
    class var sharedInstance : SearchManager {
    struct Static {
        static let instance : SearchManager = SearchManager()
        }
        return Static.instance
    }
    
    //Location specific variables.
    let locationManager:CLLocationManager = CLLocationManager()
    var lastSuccessfulSearchLocation:CLLocation? = nil
    var location:CLLocation? = nil
    
    private override init() {
        super.init()
        
        //Begins monitoring for the current location.
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        //We have found our location so turn off the GPS to preserve battery life.
        self.locationManager.stopUpdatingLocation()
        
        if self.location == nil {
            
            self.location = self.locationManager.location
            var placemark:CLPlacemark!
            CLGeocoder().reverseGeocodeLocation(self.locationManager.location, completionHandler: {(placemarks,
                error)->Void in
                
                let pm = placemarks as? [CLPlacemark]
                if pm?.count > 0 {
                    placemark = pm?[0]
                }
                
                ResultStore.sharedInstance.locateNearbyBeers(placemark)
                self.lastSuccessfulSearchLocation = placemark.location
                self.location = nil
            })
        } else {
            println("Location has already been set and a request has been made to the beerfinder web service. We don't want to make multiple requests.")
        }
    }
    
    func performSearch() {
        self.locationManager.startUpdatingLocation()
    }
}