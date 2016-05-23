//
//  CreateVoteViewController.swift
//  Clicker
//
//  Created by Kevin Fan on 5/22/16.
//  Copyright © 2016 CS M117. All rights reserved.
//

import UIKit

class CreateVoteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true);
    }

}
