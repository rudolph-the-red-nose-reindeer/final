//
//  ViewController.swift
//  bluetap
//
//  Created by Nicha Thongtanakul on 24/11/19.
//  Copyright © 2019 Nicha Thongtanakul. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, ModelDelegate {
    

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var breakLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var chaseButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    
    var tapEffect: AVAudioPlayer?
    var tingEffect: AVAudioPlayer?
    

    
    let game = Model()
    
    
    override func viewDidLoad() {
        playTap()
        statusLabel.text = ""
        game.delegate = self
        chaseButton.setImage(UIImage(named: "mark-x"), for: .normal)
        pauseButton.setImage(UIImage(named: "iconfinder_button-pause_blue_68685"), for: .normal)
        game.status = Model.gameState.play
        game.startTimer()
        scoreLabel.text = "Score: \(game.score)"
        self.navigationController?.navigationBar.isUserInteractionEnabled = false;
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray;
        
    }
    
    func isOver() {
        performSegue(withIdentifier: "gameOverSegue", sender: self)
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func updateTimeLabel() -> () {
        timerLabel.text = "\(timeFormatted(game.totalTime))"
        
    }
    
    func updateBreakLabel() -> () {
        statusLabel.text = "Get Ready!"
        breakLabel.text = "\(game.breakTime)"
    }
    
    func breakOver() {
        statusLabel.text = ""
        breakLabel.text = ""
        if (game.status == Model.gameState.restartCount) {       
            moveButton()
        }
        pauseButton.isEnabled = true
        restartButton.isEnabled = true
        game.status = Model.gameState.play
        pauseButton.setImage(UIImage(named: "iconfinder_button-pause_blue_68685"), for: .normal)
        chaseButton.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! GameOver
        vc.score = game.score
    }
    @IBAction func tappedButton(button: UIButton) {
        playTing()
        game.caught = true
        game.update()
        moveButton()
        
    }
    
    func moveButton() -> () {
        scoreLabel.text = "Score: \(game.score)"
        let buttonWidth = chaseButton.frame.width
        let buttonHeight = chaseButton.frame.height
        
        let viewWidth = chaseButton.superview!.bounds.width
        let viewHeight = chaseButton.superview!.bounds.height - chaseButton.superview!.safeAreaInsets.top - chaseButton.superview!.safeAreaInsets.bottom - 100
        
        let xwidth = viewWidth - buttonWidth
        let yheight = viewHeight - buttonHeight
        
        
        let xoffset = CGFloat(arc4random_uniform(UInt32(xwidth)))
        let yoffset = CGFloat(arc4random_uniform(UInt32(yheight)))
        
        chaseButton.center.x = xoffset + buttonWidth / 2
        chaseButton.center.y = chaseButton.superview!.safeAreaInsets.bottom + 100 + yoffset + buttonHeight / 2
    }
    
    @IBAction func tappedRestartButton(button: UIButton) {
        chaseButton.isEnabled = false
        pauseButton.isEnabled = false
        playTap()
        game.status = Model.gameState.restartCount
        game.startTimer()
        
    }
    
    @IBAction func tappedPause(button: UIButton) {
        statusLabel.text = "Paused"
        restartButton.isEnabled = false
        playTap()
        switch game.status {
        case .play:
            chaseButton.isEnabled = false
            game.status = Model.gameState.pause
            pauseButton.setImage(UIImage(named: "iconfinder_button-play_blue_68686"), for: .normal)
            
        case .pause:
            game.status = Model.gameState.pauseCount
            game.startTimer()
            
        default: break
        }
    }
    
    func playTap() ->() {
        
        let path = Bundle.main.path(forResource: "sound82", ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        do {
            tapEffect = try AVAudioPlayer(contentsOf: url)
            tapEffect?.play()
        } catch {}
        
    }
    
    func playTing() ->() {
        
        let path = Bundle.main.path(forResource: "sound99", ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        do {
            tingEffect = try AVAudioPlayer(contentsOf: url
            )
            tingEffect?.play()
        } catch {}
        
    }
    
}



