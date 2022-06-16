//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation



class ViewController: UIViewController {
    
    var audioPlayer : AVAudioPlayer!
    
    @IBOutlet weak var timerProgressBar: UIProgressView!
    @IBOutlet weak var titleLable: UILabel!
    let eggTimes = ["Soft": 3 ,
                    "Medium": 4 ,
                    "Hard": 7
    ]
    var secondPassed : Int = 0
    var currentMaxTime = 0
    var timer = Timer()
    
    @IBAction func hardnessSelcted(_ sender: UIButton) {
        

        let hardness = sender.currentTitle!
        currentMaxTime = eggTimes[hardness]!
        timerProgressBar.progress = 0
        titleLable.text = hardness

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func updateCounter(){
        
        if secondPassed < currentMaxTime {
            secondPassed += 1
            timerProgressBar.progress = Float(secondPassed)/Float(currentMaxTime)
        } else {
            timer.invalidate()
            titleLable.text = "Done"
            secondPassed = 0
            playAlarmAudio()
        }
    }
    
    func playAlarmAudio(){
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")else {return}
        do {
            // run the audio even if phone is silent
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            // set optional player attribute
            try audioPlayer =  AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        }catch let error {
            print(error.localizedDescription)
        }
    }
}
