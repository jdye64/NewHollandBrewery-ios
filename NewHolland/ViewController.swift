//
//  ViewController.swift
//  NewHolland
//
//  Created by Jeremy Dyer on 9/16/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var resultFilter: UIView!
    @IBOutlet weak var milesSlider: UISlider!
    @IBOutlet weak var milesDistFilterLabel: UILabel!
    
    var _constraintsHiddenState:Array<AnyObject>!
    var _constraintsVisibleState:Array<AnyObject>!
    var headerHidden:Bool = true
    var searchManager:SearchManager = SearchManager.sharedInstance
    
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
        
        self.updateWithinMilesFilterLabel()
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
        ResultStore.sharedInstance.filterResults()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}