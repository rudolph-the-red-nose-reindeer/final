//
//  ViewController.swift
//  bluetap
//
//  Created by Nicha Thongtanakul on 24/11/19.
//  Copyright © 2019 Nicha Thongtanakul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    

    
    let game = model()
    
    override func viewDidLoad() {
        button.setImage(UIImage(named: "mark-x"), for: .normal)
        pauseButton.setTitle("pause", for: UIControl.State.normal)
        game.startTimer()
        play()
        
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func updateTimeLabel() -> () {
        timerLabel.text = "\(timeFormatted(game.totalTime))"
    }
   
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! gameOver
        vc.score = game.score
        vc.difference = game.score - game.highscore
        vc.highscore = game.highscore
    }
    
    func play() -> () {
        while true {
            switch game.status {
            case .play:
                scoreLabel.text = "Score: \(game.score)"
            case .pause: break //stop timer //stop button
            case .over: performSegue(withIdentifier: "gameOverSegue", sender: self)
            }
        }
    }
    
    @IBAction func moveButton(button: UIButton) {
        game.caught = true
        let buttonWidth = button.frame.width
        let buttonHeight = button.frame.height

        let viewWidth = button.superview!.bounds.width
        let viewHeight = button.superview!.bounds.height + 73
        

        let xwidth = viewWidth - buttonWidth
        let yheight = viewHeight - buttonHeight
        

        let xoffset = CGFloat(arc4random_uniform(UInt32(xwidth)))
        let yoffset = CGFloat(arc4random_uniform(UInt32(yheight)))
        
        button.center.x = xoffset + buttonWidth / 2
        button.center.y = yoffset + buttonHeight / 2
    }
        
   @IBAction func tappedPause(button: UIButton) {
    switch game.status {
    case .play:
        game.status = model.gameState.pause
        pauseButton.setTitle("play", for: UIControl.State.normal)
        button.setImage(UIImage(named: "mark-none"), for: .normal)
    case .pause:
        game.status = model.gameState.play
        pauseButton.setTitle("pause", for: UIControl.State.normal)
        button.setImage(UIImage(named: "mark-x"), for: .normal)
    default: break
    }
    
    }
}



