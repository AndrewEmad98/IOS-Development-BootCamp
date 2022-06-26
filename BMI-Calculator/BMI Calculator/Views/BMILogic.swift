//
//  BMILogic.swift
//  BMI Calculator
//
//  Created by Andrew Emad on 25/06/2022.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import UIKit

struct BMILogic {
    private var person = Person()
    private var bmi : BMI?
    
    mutating func calculateBMI() {
        let bmiValue = Float(person.weight)/(person.height * person.height)
        if bmiValue < 18.5 {
            bmi = BMI(value: bmiValue, advice: "Eat more Pies", color: UIColor.blue)
        } else if bmiValue < 24.9 {
            bmi = BMI(value: bmiValue, advice: "Fit as a fiddle", color: UIColor.green)
        }else {
            bmi = BMI(value: bmiValue, advice: "Eat less Pies", color: UIColor.red)
        }
    }
    mutating func setPersonValues(weight : Int , height : Float){
        person.weight = weight
        person.height = height
    }
    func getFormatedBMIValue() -> String {
        return String(format: "%.2f", bmi?.value ?? 0.0)
    }
    func getBMIAdvice() -> String {
        return bmi?.advice ?? "No Advice"
    }
    func getBMIColour() -> UIColor {
        return bmi?.color ?? UIColor.blue
    }
}
