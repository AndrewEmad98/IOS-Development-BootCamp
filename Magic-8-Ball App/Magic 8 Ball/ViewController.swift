//
//  ViewController.swift
//  Magic 8 Ball
//
//  Created by Angela Yu on 14/06/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var ballImageView: UIImageView!
    let ballImages = ["ball1",
                      "ball2",
                      "ball3",
                      "ball4",
                      "ball5",
    ]
    let noOfImages = 5
    var currentImageNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func askButtonClicked(_ sender: UIButton) {
        var rand1 = Int.random(in: 1...noOfImages)
        while rand1 == currentImageNumber {
            rand1 = Int.random(in: 1...noOfImages)
        }
        ballImageView.image = UIImage(named: ballImages[rand1-1])
        currentImageNumber = rand1
    }
    

}

