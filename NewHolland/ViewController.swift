//
//  ViewController.swift
//  NewHolland
//
//  Created by Jeremy Dyer on 9/16/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var resultFilter: UIView!
    @IBOutlet weak var milesSlider: UISlider!
    @IBOutlet weak var milesDistFilterLabel: UILabel!
    @IBOutlet weak var beerFilterPicker: UIPickerView!
    
    var _constraintsHiddenState:Array<AnyObject>!
    var _constraintsVisibleState:Array<AnyObject>!
    var headerHidden:Bool = true
    //var searchManager:SearchManager = SearchManager.sharedInstance
    
    var currentSelectedBeerFromPicker:String? = nil
    
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
        
        self.beerFilterPicker.delegate = self
        self.beerFilterPicker.dataSource = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "datasourceUpdated:", name: ResultStore.sharedInstance.NHBResultsUpdated, object: nil)
        
        self.updateWithinMilesFilterLabel()
    }
    
    //Notified by NSNotification event when the ResultStore datasource has been filtered or loaded
    func datasourceUpdated(notification: NSNotification) {
        self.beerFilterPicker.reloadAllComponents()
    }
    
    //Exmines the current state of all of the filtering components and generates a filter criteria to feed to the ResultStore for filtering
    func filterByCriteria() {
        println("Filtering search results by criteria")
        var fc = FilterCriteria()
        fc.maxMiles = ResultStore.sharedInstance.currentMilesFilterUnder
        fc.brand = self.currentSelectedBeerFromPicker
        ResultStore.sharedInstance.filterResults(fc)
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
    
    
    //SLIDER CALLBACKS FOR HANDLING THE DISTANCE FILTERING
    
    @IBAction func milesSliderValueChanged(sender: AnyObject) {
        ResultStore.sharedInstance.currentMilesFilterUnder = ResultStore.sharedInstance.milesRadiusMax * self.milesSlider.value
        self.updateWithinMilesFilterLabel()
    }
    
    func updateWithinMilesFilterLabel() {
        self.milesDistFilterLabel.text = String(format: "Within %.1f miles", ResultStore.sharedInstance.currentMilesFilterUnder)
    }
    
    @IBAction func touchUpInside(sender: AnyObject) {
        println("Done changing the value of the miles slider")
        //ResultStore.sharedInstance.filterResults()
        self.filterByCriteria()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UIPICKER VIEW METHODS
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ResultStore.sharedInstance.beerList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return ResultStore.sharedInstance.beerList[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentSelectedBeerFromPicker = ResultStore.sharedInstance.beerList[row]
        self.filterByCriteria()
    }
    
}