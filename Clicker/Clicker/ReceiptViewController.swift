//
//  ReceiptViewController.swift
//  Clicker
//
//  Created by Kevin Fan on 5/22/16.
//  Copyright © 2016 CS M117. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var optionALabel: UILabel!
    @IBOutlet weak var optionBLabel: UILabel!
    @IBOutlet weak var optionCLabel: UILabel!
    @IBOutlet weak var optionDLabel: UILabel!
    
    var titleLabelText = String()
    var detailLabelText = String()
    var optionALabelText = String()
    var optionBLabelText = String()
    var optionCLabelText = String()
    var optionDLabelText = String()
    var idLabelText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idLabel.text = idLabelText.uppercaseString
        titleLabel.text = titleLabelText.capitalizedString
        detailLabel.text = detailLabelText.capitalizedString
        optionALabel.text = optionALabelText.capitalizedString
        optionBLabel.text = optionBLabelText.capitalizedString
        optionCLabel.text = optionCLabelText.capitalizedString
        optionDLabel.text = optionDLabelText.capitalizedString
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
