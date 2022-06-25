//
//  ViewController.swift
//  Destini-iOS13
//
//  Created by Angela Yu on 08/08/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var story = StoryLogic()
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var choice1Button: UIButton!
    @IBOutlet weak var choice2Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    @IBAction func choiceMade(_ sender: UIButton) {
        let choice = sender.currentTitle!
        story.changeStoryByChoice(choiceClicked: choice)
        updateUI()
    }
    
    func updateUI(){
        storyLabel.text = story.getCurrentStory()
        let choices = story.getCurrentStoryChoices()  // return 2 choices as a tuple
        choice1Button.setTitle(choices.c1, for: .normal)
        choice2Button.setTitle(choices.c2, for: .normal)
    }
}

