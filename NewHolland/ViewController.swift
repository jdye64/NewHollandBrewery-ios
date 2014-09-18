//
//  ViewController.swift
//  NewHolland
//
//  Created by Jeremy Dyer on 9/16/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var resultFilter: UIView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var beerResultsTable: UITableView!
    
    var _constraintsHiddenState:Array<AnyObject>!
    var _constraintsVisibleState:Array<AnyObject>!
    
    var headerHidden:Bool = true
    
    
    let cellIdentifier = "cellIdentifier"
    var tableData: NSArray = [String]()
    
    //These values are hardcoded for the time being until the filter view is implemented
    let sampleLat = "33.8092255"
    let sampleLong = "-84.28054780000002"
    let sampleB = "" //Full text string indicating the drink you are searching for
    let sampleT = "off" //on means search taverns and bars. off means search only stores where it can be purchased
    let sampleM = "10" //Radius in miles to perform the search for
    let sampleD = "Decatur, GA 30033" //Location to search from
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewBindingsDict: NSMutableDictionary = NSMutableDictionary()
        viewBindingsDict.setValue(resultFilter, forKey: "resultFilter")
        viewBindingsDict.setValue(filterButton, forKey: "filterButton")
        self._constraintsHiddenState = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(-75)-[resultFilter]", options: nil, metrics: nil, views: viewBindingsDict)
        self._constraintsVisibleState = NSLayoutConstraint.constraintsWithVisualFormat("V:|[resultFilter]", options: nil, metrics: nil, views: viewBindingsDict)
        
        //Initialize the view as hidden
        self.view.addConstraints(self._constraintsHiddenState)
        
        //Sets the table delegate to this controller
        self.beerResultsTable.registerClass(ResultTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        self.beerResultsTable.delegate = self
        
        //Test locating the nearby beers.
        self.locateNearbyBeers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func testing(sender: AnyObject) {
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
        
        Alamofire.request(.GET, "http://localhost:5000/beerfinder", parameters: params)
            .responseJSON { (request, response, json, error) in
                println(json)
                var jsonResult = json as Dictionary<String, NSArray>
                self.tableData = jsonResult["results"] as NSArray!
                self.beerResultsTable.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as UITableViewCell        
        var cellText: String = self.tableData[indexPath.row]["dba"] as String
        var cellAddress: String = self.tableData[indexPath.row]["address"] as String
        cellText += " - "
        cellText += self.tableData[indexPath.row]["miles"] as String
        cell.textLabel?.text = cellText
        cell.detailTextLabel?.text = cellAddress
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedData = self.tableData[indexPath.row] as NSDictionary
        println(selectedData)
    }

}

