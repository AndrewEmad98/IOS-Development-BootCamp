//
//  ViewController.swift
//  Xylophone
//
//  Created by Angela Yu on 28/06/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
  
    var player : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonClicked(_ sender: UIButton) {
        
        let myLabel = sender.currentTitle
        sender.alpha = 0.5
        playSound(buttonLabel: myLabel)
        print("Start")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            print("End")
            sender.alpha = 1
        }
    }
    
    func playSound(buttonLabel : String?) {
        if buttonLabel == nil {
            return
        }
        guard let url = Bundle.main.url(forResource: buttonLabel, withExtension: "wav") else {return}
        do {
            // run the audio even if phone is silent
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            // set optional player attribute 
            try player =  AVAudioPlayer(contentsOf: url)
            player?.play()
        }catch let error {
            print(error.localizedDescription)
        }
    }

}

