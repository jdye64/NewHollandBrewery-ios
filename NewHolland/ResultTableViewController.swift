//
//  ResultTableViewController.swift
//  NewHolland
//
//  Created by Jeremy Dyer on 9/19/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

import Foundation
import UIKit

class ResultTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var resultsTable: UITableView!
    //@IBOutlet weak var searchActivityIndicator: UIActivityIndicatorView!
    let cellIdentifier = "cellIdentifier"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.resultsTable.registerClass(ResultCell.self, forCellReuseIdentifier: self.cellIdentifier)
        self.resultsTable.delegate = self

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = UIColor.darkGrayColor()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Locating Beers Nearby")
        self.refreshControl?.addTarget(self, action: "reloadData:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl?.beginRefreshing()
        
        //Registers the UITableViewController to listen for updates to the datasource from filtering, loading results, etc
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "datasourceUpdated:", name: ResultStore.sharedInstance.NHBResultsUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "searchBeganNotification:", name: ResultStore.sharedInstance.NHBSearchBegan, object: nil)
    }
    
    func reloadData(sender: AnyObject) {
        SearchManager.sharedInstance.performSearch()
    }
    
    //Notify tableviewcontroller that loading of results has begun
    func searchBeganNotification(notification: NSNotification) {
        self.refreshControl?.beginRefreshing()
    }
    
    //Notified by NSNotification event when the ResultStore datasource has been filtered or loaded
    func datasourceUpdated(notification: NSNotification) {
        self.resultsTable.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ResultStore.sharedInstance.resultsFiltered {
            return ResultStore.sharedInstance.filteredSearchResults.count
        } else {
            return ResultStore.sharedInstance.searchResults.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as ResultCell
        
        var searchResult:SearchResult!
        if ResultStore.sharedInstance.resultsFiltered {
            searchResult = ResultStore.sharedInstance.filteredSearchResults[indexPath.row]
        } else {
            searchResult = ResultStore.sharedInstance.searchResults[indexPath.row]
        }
        
        //var searchResult:SearchResult = self.searchResults[indexPath.row]
        var cellText: String = searchResult.dba
        var cellAddress: String = searchResult.address
        var cellMiles:String = String(format: "%.2f", searchResult.milesFromCurrentLocation)
        
        cell.textLabel?.text = cellText
        cell.detailTextLabel?.text = cellAddress
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var selectedSearchResult:SearchResult = self.searchResults[indexPath.row]
//        println(selectedSearchResult)
        println("Selected a row in the table. This logic is not yet implemented. Hold tight")
    }
    
}