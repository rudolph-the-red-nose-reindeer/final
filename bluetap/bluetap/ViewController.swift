//
//  ViewController.swift
//  bluetap
//
//  Created by Nicha Thongtanakul on 24/11/19.
//  Copyright © 2019 Nicha Thongtanakul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var gameStatus: UILabel!
    @IBOutlet weak var chase: UIButton!
    let game = model()
    /* from tictactoe
    @IBAction func buttonTapped(_ sender: UIButton) {
        game.update(button: sender.tag)
        let b = game.grid[sender.tag]
        if b == .p1 {
            sender.setImage(UIImage(named: "mark-x"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "mark-o"), for: .normal)
        }
        game.check()
        score.text = "Score: \(game.score)"
        switch game.status {
        case .p1Wins:
            gameStatus.textColor = UIColor.green
            gameStatus.text = "Player 1 Wins!"
            disableButtons()
            action.setTitle("Play Again!", for: .normal)
        case .p2Wins:
            gameStatus.textColor = UIColor.green
            gameStatus.text = "Player 2 Wins!"
            disableButtons()
            action.setTitle("Play Again!", for: .normal)
        case .draw:
            gameStatus.text = "Draw"
            disableButtons()
            action.setTitle("Play Again!", for: .normal)        case .p1Turn:
                gameStatus.text = "Player 1's Turn!"
        case .p2Turn:
            gameStatus.text = "Player 2's Turn!"
        }
    }
    
    @IBAction func clearTap(_ sender: UIButton) {
        gameStatus.textColor = UIColor.black
        gameStatus.text = "Player 1's Turn!"
        for index in 0...8 { collectionOfButtons![index].setImage(UIImage(named: "mark-none"), for: .normal)
            collectionOfButtons![index].isEnabled = true
        }
        action.setTitle("clear", for: .normal)
        game.reset()
    }
    func disableButtons() {
        for index in 0...8 {
            collectionOfButtons![index].isEnabled = false
        }
    }
    */
}
class model {
    
    var caught: Bool = false
    var score: Int = 0
    var status: gameState = .over
    enum gameState{
        case play
        case pause
        case over
        
    }
    
    func check() -> () {
        checkOver()
        checkPaused()
    }
    
    func checkOver() -> () {
    //if timer is up status = .over
    }
    
    func checkPaused() -> () {
        //if paused is pressed status = .paused
        //pause timer
        //activate play button-countdown before gamestarts?
        
    }
    
    func update(caught: Bool) {
        check()
        if caught {
            move()
            caught = false
        }
    }
    
    func move() {
        // button.x = math.random() * safe area something
        //button.y =
    }
    
    func reset() -> () {
        //set timer to full
        //status = .over
        //set play button to active
    }
    

}


