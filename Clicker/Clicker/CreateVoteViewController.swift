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
    
    var vote : [String: String] {
        get {
            return [
                "title": titleField.text!,
                "detail": detailField.text!,
                "optionA": optionAField.text!,
                "optionB": optionBField.text!,
                "optionC": optionCField.text!,
                "optionD": optionDField.text!,
                "voteID": randomAlphaNumericString(10)
            ]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func createButtonDidTouch(sender: AnyObject) {
        print(vote["voteID"])
    }
    
    func randomAlphaNumericString(length: Int) -> String {
        
        let allowedChars = "abcdefghijklmnopqrstuvwxyz0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in (0..<length) {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars[allowedChars.startIndex.advancedBy(randomNum)]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationController : ReceiptViewController = segue.destinationViewController as! ReceiptViewController
        destinationController.titleLabelText = vote["title"]!
        destinationController.detailLabelText = vote["detail"]!
        destinationController.optionALabelText = vote["optionA"]!
        destinationController.optionBLabelText = vote["optionB"]!
        destinationController.optionCLabelText = vote["optionC"]!
        destinationController.optionDLabelText = vote["optionD"]!
        destinationController.idLabelText = vote["voteID"]!
        
    }
}
