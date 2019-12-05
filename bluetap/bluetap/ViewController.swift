//
//  ViewController.swift
//  bluetap
//
//  Created by Nicha Thongtanakul on 24/11/19.
//  Copyright © 2019 Nicha Thongtanakul. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ModelDelegate {

    func isOver() {
        performSegue(withIdentifier: "gameOverSegue", sender: self)
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var chaseButton: UIButton!

    @IBOutlet weak var pauseButton: UIButton!
    

    
    let game = Model()
    
    override func viewDidLoad() {
        game.delegate = self
        chaseButton.setImage(UIImage(named: "mark-x"), for: .normal)
        pauseButton.setTitle("pause", for: UIControl.State.normal)
        game.startTimer()
        scoreLabel.text = "Score: \(game.score)"
        self.navigationController?.navigationBar.isUserInteractionEnabled = false;
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray;
        
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
        let vc = segue.destination as! GameOver
        vc.score = game.score
    }
    
    
    @IBAction func moveButton(button: UIButton) {
        game.caught = true
        game.update()
        scoreLabel.text = "Score: \(game.score)"
        let buttonWidth = button.frame.width
        let buttonHeight = button.frame.height

        let viewWidth = button.superview!.bounds.width
        let viewHeight = button.superview!.bounds.height - button.superview!.safeAreaInsets.top - button.superview!.safeAreaInsets.bottom - 100

        let xwidth = viewWidth - buttonWidth
        let yheight = viewHeight - buttonHeight
        

        let xoffset = CGFloat(arc4random_uniform(UInt32(xwidth)))
        let yoffset = CGFloat(arc4random_uniform(UInt32(yheight)))
        
        button.center.x = xoffset + buttonWidth / 2
        button.center.y = button.superview!.safeAreaInsets.bottom + 100 + yoffset + buttonHeight / 2
    }
        
   @IBAction func tappedPause(button: UIButton) {
    switch game.status {
    case .play:
        chaseButton.isEnabled = false
        game.status = Model.gameState.pause
        pauseButton.setTitle("play", for: UIControl.State.normal)
        //button.setImage(UIImage(named: "mark-none"), for: .normal)
        
    case .pause:
        game.status = Model.gameState.play
        pauseButton.setTitle("pause", for: UIControl.State.normal)
        chaseButton.setImage(UIImage(named: "mark-x"), for: .normal)
        chaseButton.isEnabled = true
    default: break
    }
    
    }
}



