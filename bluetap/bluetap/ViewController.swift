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
        
    @IBOutlet weak var breakLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var chaseButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    let game = Model()
    var tapEffect: AVAudioPlayer?
    var tingEffect: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        let path1 = Bundle.main.path(forResource: "sound82.wav", ofType: nil)!
        let url1 = URL(fileURLWithPath: path1)
        let path2 = Bundle.main.path(forResource: "sound99.wav", ofType: nil)!
        let url2 = URL(fileURLWithPath: path2)
        do {
            tapEffect = try AVAudioPlayer(contentsOf: url1)
        } catch {
        }
        do {
            tingEffect = try AVAudioPlayer(contentsOf: url2)
        } catch {
        }
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
        breakLabel.text = "\(game.breakTime)"
    }
    
    func breakOver() {
        breakLabel.text = ""
        if (game.status == Model.gameState.restartCount) {
            game.reset()
            game.startTimer()
            moveButton()
        }
        
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
        game.caught = true
        game.update()
        moveButton()
        
    }
    
    func moveButton() -> () {
        tapEffect?.stop()
        tingEffect?.stop()
        tingEffect?.play()
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
        tapEffect?.stop()
        tingEffect?.stop()
        tapEffect?.play()
        game.status = Model.gameState.restartCount
        game.startThreeSecTimer()
        
    }
    
    @IBAction func tappedPause(button: UIButton) {
        tapEffect?.stop()
        tingEffect?.stop()
        tapEffect?.play()
        switch game.status {
        case .play:
            chaseButton.isEnabled = false
            game.status = Model.gameState.pause
            pauseButton.setImage(UIImage(named: "iconfinder_button-play_blue_68686"), for: .normal)
            
        case .pause:
            game.status = Model.gameState.pauseCount
            game.startThreeSecTimer()
            
        default: break
        }
    }
}



