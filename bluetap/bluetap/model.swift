//
//  model.swift
//  bluetap
//
//  Created by Nicha Thongtanakul on 4/12/19.
//  Copyright © 2019 Nicha Thongtanakul. All rights reserved.
//

import UIKit

class model {
    
    let defaults = UserDefaults.standard
    var caught: Bool = false
    var countdownTimer: Timer!
    var totalTime = 60
    var score: Int = 0
    var highscore: Int = 0
    var status: gameState = .over
    enum gameState{
        case play
        case pause
        case over
    }



    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    @objc func updateTime() {
        switch status {
        case .play:
            if totalTime != 0 {
                totalTime -= 1
            } else {
                endTimer()
            }
        default:
            break
        }
    }
    
    func checkOver() -> () {
        if (totalTime == 0) {
            status = .over
            save()
            reset()
        }
        
    }
    
    func save() -> () {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MM-yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        
        defaults.set(score, forKey: myStringafd)
    }
    
    func update(caught: Bool) {
        checkOver()
        if caught {
            score = score + 1
            self.caught = false
        }
    }

    func reset() -> () {
        score = 0
    }
    
    
}
