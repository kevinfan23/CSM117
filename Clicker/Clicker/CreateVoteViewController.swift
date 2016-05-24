//
//  CreateVoteViewController.swift
//  Clicker
//
//  Created by Kevin Fan on 5/22/16.
//  Copyright © 2016 CS M117. All rights reserved.
//

import UIKit

class CreateVoteViewController: UIViewController {
    
    @IBOutlet weak var titleField: DesignableTextField!
    @IBOutlet weak var detailField: DesignableTextField!
    @IBOutlet weak var optionAField: DesignableTextField!
    @IBOutlet weak var optionBField: DesignableTextField!
    @IBOutlet weak var optionCField: DesignableTextField!
    @IBOutlet weak var optionDField: DesignableTextField!
    @IBOutlet weak var idField: DesignableTextField!
    
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
    
    @IBAction func createButtonDidTouch(sender: AnyObject) {
        let titleFieldInput = titleField.text;
        let detailFieldInput = detailField.text;
        let optionAFieldInput = optionAField.text;
        let optionBFieldInput = optionBField.text;
        let optionCFieldInput = optionCField.text;
        let optionDFieldInput = optionDField.text;
        let idFieldInput = idField.text;
        
    }
}
