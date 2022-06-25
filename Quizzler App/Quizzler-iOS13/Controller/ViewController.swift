//
//  ViewController.swift
//  Quizzler-iOS13
//
//  Created by Angela Yu on 12/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    

   
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    var quiz = QuizLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateTextUI()
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        
        let userAnswer = sender.currentTitle!
        
        let isCorrectAnswer = quiz.calculateQuestion(userAnswer)
        isAnswerdCorrectly(isTrue: isCorrectAnswer, sender)
        quiz.nextQuestion()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ){
                self.updateTextUI()
        }
    }
    
    func updateTextUI (){
        textLabel.text = quiz.getCurrentQuestion()
        scoreLabel.text = "Score : \(quiz.getScore())"
        trueButton.backgroundColor = UIColor.clear
        falseButton.backgroundColor = UIColor.clear
        progressBar.progress = quiz.getCurrentQuestionPercentage()
    }
    func isAnswerdCorrectly ( isTrue : Bool , _ sender: UIButton ){
        if isTrue {
                sender.backgroundColor = UIColor.green
        }else {
                sender.backgroundColor = UIColor.red
        }
    }
}

