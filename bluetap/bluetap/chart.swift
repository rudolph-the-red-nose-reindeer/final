//
//  chart.swift
//  bluetap
//
//  Created by Nicha Thongtanakul on 4/12/19.
//  Copyright © 2019 Nicha Thongtanakul. All rights reserved.
//

import UIKit

class chart: UIViewController {
    
    @IBOutlet weak var highscoreLabel: UILabel!

    var status: model.gameState = .over

    override func viewDidLoad() {
        highscoreLabel.text = "Highscore: 0" // \(model.defaults.value(forKey: userSessionKey) as? Int)"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        
        let vc = segue.destination as! ViewController
        vc.game.status = model.gameState.play
}

 @IBAction func buttonTapped(_ sender: UIButton) {
    performSegue(withIdentifier: "startSegueFromHome", sender: self)
    }
    
}
