//
//  SearchingVoteViewController.swift
//  Clicker
//
//  Created by Kevin Fan on 5/24/16.
//  Copyright © 2016 CS M117. All rights reserved.
//

import UIKit

class SearchingVoteViewController: UIViewController {

    @IBOutlet weak var searchButton: DesignableButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        _ = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(SearchingVoteViewController.timeToMoveOn), userInfo: nil, repeats: false)
    }
    
    func timeToMoveOn() {
        self.performSegueWithIdentifier("searchComplete", sender: self)
    }

}
