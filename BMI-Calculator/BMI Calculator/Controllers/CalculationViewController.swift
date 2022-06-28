//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Angela Yu on 21/08/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class CalculationViewController: UIViewController {

    var bmi = BMILogic()
    
    @IBOutlet weak var weightSliderOutlet: UISlider!
    @IBOutlet weak var heightSliderOutlet: UISlider!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func weightSlider(_ sender: UISlider) {
        weightLabel.text = String(Int(sender.value)) + "kg"
    }
    @IBAction func heightSlider(_ sender: UISlider) {
        heightLabel.text = String(format: "%.2f", sender.value) + "m"
    }
    
    @IBAction func calculateBMI(_ sender: UIButton) {

        let pHeight = heightSliderOutlet.value
        let pWeight = Int(weightSliderOutlet.value)
        bmi.setPersonValues(weight: pWeight, height: pHeight)
        bmi.calculateBMI()
        

        self.performSegue(withIdentifier: "GoToResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GoToResult" {
            let calculationVC = segue.destination as! ResultViewController
            calculationVC.bmiValue = bmi.getFormatedBMIValue()
            calculationVC.bmiAdvice = bmi.getBMIAdvice()
            calculationVC.bmiColor = bmi.getBMIColour()
        }
    }
}

