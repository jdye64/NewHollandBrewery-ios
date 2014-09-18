//
//  ViewController.swift
//  NewHolland
//
//  Created by Jeremy Dyer on 9/16/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var resultFilter: UIView!
    @IBOutlet weak var beerResultsTable: UITableView!
    @IBOutlet weak var milesSlider: UISlider!
    @IBOutlet weak var milesDistFilterLabel: UILabel!
    @IBOutlet weak var searchActivityIndicator: UIActivityIndicatorView!
    
    
    var _constraintsHiddenState:Array<AnyObject>!
    var _constraintsVisibleState:Array<AnyObject>!
    
    var headerHidden:Bool = true
    
    let cellIdentifier = "cellIdentifier"
    var searchResults:[SearchResult] = []
    var filteredSearchResults:[SearchResult] = []
    
    let milesRadiusMax:Float! = 15.0
    
    var resultsFiltered:Bool = false
    var currentMilesRange:Float = 15.0
    
    //These values are hardcoded for the time being until the filter view is implemented
    var sampleLat = "33.8092255"
    var sampleLong = "-84.28054780000002"
    var sampleB = "" //Full text string indicating the drink you are searching for
    var sampleT = "off" //on means search taverns and bars. off means search only stores where it can be purchased
    var sampleM = "15" //Radius in miles to perform the search for. All request will get the maximum in distance and range will be filtered on this client side
    var sampleD = "" //Location to search from format "Decatur, GA 30033"
    
    //Location specific variables.
    let locationManager:CLLocationManager = CLLocationManager()
    var location:CLLocation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewBindingsDict: NSMutableDictionary = NSMutableDictionary()
        viewBindingsDict.setValue(self.resultFilter, forKey: "resultFilter")
        viewBindingsDict.setValue(self.milesSlider, forKey: "milesSlider")
        viewBindingsDict.setValue(self.milesDistFilterLabel, forKey: "milesDistFilterLabel")
        self._constraintsHiddenState = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(-250)-[resultFilter]", options: nil, metrics: nil, views: viewBindingsDict)
        self._constraintsVisibleState = NSLayoutConstraint.constraintsWithVisualFormat("V:|[resultFilter]", options: nil, metrics: nil, views: viewBindingsDict)
        
        //Initialize the view as hidden
        self.view.addConstraints(self._constraintsHiddenState)
        
        //Sets the table delegate to this controller
        self.beerResultsTable.registerClass(ResultCell.self, forCellReuseIdentifier: self.cellIdentifier)
        self.beerResultsTable.delegate = self
        
        self.updateWithinMilesFilterLabel()
        
        println("Slider size information width \(self.milesSlider.frame.width) height \(self.milesSlider.frame.height)")
        
        //Test locating the nearby beers.
        //self.locateNearbyBeers()
        
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
                
                self.sampleD = String(format: "%@, %@ %@", placemark.locality, placemark.administrativeArea, placemark.postalCode)
                self.sampleLat = String(format: "%.10f", self.locationManager.location.coordinate.latitude)
                self.sampleLong = String(format: "%.10f", self.locationManager.location.coordinate.longitude)
                
                println("Location: \(self.sampleD) Latitude: \(self.sampleLat) Longitude: \(self.sampleLong)")
                
                self.locateNearbyBeers()
            })
        } else {
            println("Location has already been set and a request has been made to the beerfinder web service. We don't want to make multiple requests.")
        }
    }

    @IBAction func resultViewSwipedDown(sender: AnyObject) {
        self.toggleResultFilterVisibility()
    }
    
    @IBAction func resultViewSwipedUp(sender: AnyObject) {
        self.toggleResultFilterVisibility()
    }
    
    func toggleResultFilterVisibility() {
        if (self.headerHidden) {
            self.view.removeConstraints(self._constraintsHiddenState)
            self.view.addConstraints(self._constraintsVisibleState)
        } else {
            self.view.removeConstraints(self._constraintsVisibleState)
            self.view.addConstraints(self._constraintsHiddenState)
        }
        
        //Animates the view
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutIfNeeded()
        })
        
        self.headerHidden = !self.headerHidden
    }
    
    
    //UITABLEVIEW COMPONENTS TO MANAGE THE OBJECTS
    
    func locateNearbyBeers() {
        let params:[String:AnyObject] = ["lat": self.sampleLat,
            "long": self.sampleLong,
            "b": self.sampleB,
            "t": self.sampleT,
            "m": self.sampleM,
            "d": self.sampleD]
        
        //Commented out as the server is not currently running
        self.searchActivityIndicator.startAnimating()
        Alamofire.request(.GET, "http://beerfinder.jeremydyer.me/beerfinder", parameters: params)
            .responseJSON { (request, response, json, error) in
                println(json)
                var jsonResult = json as Dictionary<String, NSArray>
                
                //Clear the past search results.
                self.searchResults = []
                self.filteredSearchResults = []
                
                //Creates the SearchResult objects from the JSON Response
                var results:NSArray = jsonResult["results"] as NSArray!
                for result in results {
                    var searchResult:SearchResult = SearchResult(jsonResult:result as NSDictionary)
                    self.searchResults.append(searchResult)
                }
                
                self.beerResultsTable.reloadData()
                
                self.searchActivityIndicator.stopAnimating()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultsFiltered {
            return self.filteredSearchResults.count
        } else {
            return self.searchResults.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as ResultCell
        
        var searchResult:SearchResult!
        if self.resultsFiltered {
            searchResult = self.filteredSearchResults[indexPath.row]
        } else {
            searchResult = self.searchResults[indexPath.row]
        }
        
        //var searchResult:SearchResult = self.searchResults[indexPath.row]
        var cellText: String = searchResult.dba
        var cellAddress: String = searchResult.address
        var cellMiles:String = String(format: "%.2f", searchResult.milesFromCurrentLocation)

        cell.textLabel?.text = cellText
        cell.detailTextLabel?.text = cellAddress
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedSearchResult:SearchResult = self.searchResults[indexPath.row]
        println(selectedSearchResult)
    }
    
    
    //SLIDER CALLBACKS FOR HANDLING THE DISTANCE FILTERING
    
    @IBAction func milesSliderValueChanged(sender: AnyObject) {
        self.currentMilesRange = self.milesRadiusMax * self.milesSlider.value
        self.updateWithinMilesFilterLabel()
    }
    
    func updateWithinMilesFilterLabel() {
        self.milesDistFilterLabel.text = String(format: "Within %.1f miles", self.currentMilesRange)
    }
    
    @IBAction func touchUpInside(sender: AnyObject) {
        println("Done changing the value of the miles slider")
        self.filterResults()
    }
    
    //FUNCTIONS TO FILTER THE RESULTS BASED ON THE WISHES OF THE USER
    func filterResults() {
        self.resultsFiltered = true
        println("Filtering the results")
        
        //Clears the existing filered results.
        self.filteredSearchResults = []
        
        //Right now only filtering by miles so narrow the results down to the locations that are within the miles range
        println("Filtering to result under \(self.currentMilesRange) miles")
        for searchResult in self.searchResults {
            if searchResult.milesFromCurrentLocation <= self.currentMilesRange {
                self.filteredSearchResults.append(searchResult)
            }
        }
        
        println("Original Search Results Size -> \(self.searchResults.count) Filtered Search Results Size -> \(self.filteredSearchResults.count)")
        self.beerResultsTable.reloadData()
        
    }
    
    func clearFilteredResults() {
        println("Clearing the filtered results")
        self.resultsFiltered = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}