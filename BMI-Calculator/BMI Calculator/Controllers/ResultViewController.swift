//
//  ResultViewController.swift
//  BMI Calculator
//
//  Created by Andrew Emad on 26/06/2022.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    var bmiValue : String?
    var bmiAdvice : String?
    var bmiColor = UIColor.blue
    
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = bmiValue
        adviceLabel.text = bmiAdvice
        view.backgroundColor = bmiColor
        
    }
    
    @IBAction func reCalculateClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
