//
//  model.swift
//  bluetap
//
//  Created by Nicha Thongtanakul on 4/12/19.
//  Copyright © 2019 Nicha Thongtanakul. All rights reserved.
//

import UIKit

protocol ModelDelegate: class {
    func isOver()
    func updateTimeLabel()
    func breakOver()
    func updateBreakLabel()
}

class Model {
    
    weak var delegate: ModelDelegate!
    static var defaults = UserDefaults.standard
    var caught: Bool = false
    var countdownTimer: Timer!
    var totalTime: Int = 20
    var breakTime: Int = 3
    var score: Int = 0
    var formatter: DateFormatter = DateFormatter()
    var status: gameState = .over
    enum gameState{
        case play
        case pause
        case over
        case pauseCount
        case restartCount
    }
    
    struct gamePlay {
        let date: Date
        let score: Int
    }
    
    var scores = [gamePlay]()
    
    func startTimer() {
        if (countdownTimer != nil) {
            countdownTimer.invalidate()
        }
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        switch status {
        case .play:
            delegate.updateTimeLabel()
        case .pauseCount, .restartCount:
            
            delegate.updateBreakLabel()
            
        default:
            break
        }
        
    }
    
    
    
    
    @objc func updateTime() {
        switch status {
        case .play:
            if totalTime != 0 {
                totalTime -= 1
                delegate.updateTimeLabel()
            } else {
                endTimer()
            }
        case .pauseCount, .restartCount:
            if breakTime != 0 {
                breakTime -= 1
                delegate.updateBreakLabel()
            } else {
                endTimer()
            }
        default:
            break
        }
        
    }
    
    
    
    
    
    
    func save() -> () {
        
        formatter.dateFormat = "yyyy-MM-dd"
        if (score > Model.defaults.integer(forKey: "highscore")) {
            Model.defaults.set(score, forKey: "highscore")
        }
        
        
        if (Model.defaults.object(forKey: formatter.string(from: Date())) == nil) {
            Model.defaults.set(score, forKey: formatter.string(from: Date()))
        } else {
            if (score > Model.defaults.integer(forKey: formatter.string(from: Date()))) {
                Model.defaults.set(score, forKey: formatter.string(from: Date()))
            }
        }
    }
    
    func update() {
        if caught {
            score = score + 1
            self.caught = false
        }
    }
    
    func resetGame() -> () {
        score = 0
        totalTime = 20
    }
    
    func resetBreakTime() -> () {
        breakTime = 3
    }
    
    
    func endTimer() {
        
        switch status {
        case .play:
            delegate.isOver()
            status = .over
            save()
            resetGame()
            resetBreakTime()
            
            
        case .pauseCount:
            delegate.breakOver()
            status = .play
            resetBreakTime()
            startTimer()
            
            
        case .restartCount:
            delegate.breakOver()
            status = .play
            resetGame()
            resetBreakTime()
            startTimer()
        default:
            break
        }
        
    }
}
