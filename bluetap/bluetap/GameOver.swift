//
//  gameOver.swift
//  bluetap
//
//  Created by Nicha Thongtanakul on 4/12/19.
//  Copyright © 2019 Nicha Thongtanakul. All rights reserved.
//

import UIKit

class GameOver: UIViewController {
    



    @IBOutlet weak var congrats: UILabel!
    @IBOutlet weak var yourScore: UILabel!

    @IBOutlet weak var highScore: UILabel!
    
    
    
    
    var difference: Int = 0
    var score: Int = 0
    var highscore: Int = 0
   
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isUserInteractionEnabled = false;
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray;
        highscore = Model.defaults.integer(forKey: "highscore")
        difference = score - highscore
        yourScore.text = "Score: \(score)"
        highScore.text = "Highscore: \(highscore)"
        if (difference > 0) {
            congrats.text = "yay, you beat your highscore!!"
        } else if (difference > -5){
            congrats.text = "oof, so close to beating your highscore"
        } else {
            congrats.text = "awww better luck next time :("
        }
        
        
    }
    
    
        
}
