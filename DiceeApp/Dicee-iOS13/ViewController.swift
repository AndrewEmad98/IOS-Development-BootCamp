//
//  ViewController.swift
//  Dicee-iOS13
//
//  Created by Angela Yu on 11/06/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // make IBOutlets refrences(Connections) to 2 ImageViews in UI StoryBoard
    @IBOutlet weak var diceImageView1: UIImageView!
    @IBOutlet weak var diceImageView2: UIImageView!
    // array of names of rolls images
    let rolls : [String] = ["DiceOne",
                            "DiceTwo",
                            "DiceThree",
                            "DiceFour",
                            "DiceFive",
                            "DiceSix"
    ]
    // main func that run when screen Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        // change image View's image
        
    }
    // make IBAction refrence ( connection ) to Button View and check if button clicked
    @IBAction func rollButtonClicked(_ sender: Any) {
        // create two random numbers between 0 to 5 included
        let rand1 = Int.random(in: 0...5)
        let rand2 = Int.random(in: 0...5)
        // change 2 image views's images
        diceImageView1.image = UIImage(named: rolls[rand1])
        diceImageView2.image = UIImage(named: rolls[rand2])
    }

}

