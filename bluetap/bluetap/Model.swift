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
    var breakTimer: Timer!
    var totalTime: Int = 0
    var breakTime: Int = 0
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
    
    func startThreeSecTimer() {
        breakTime = 3
        delegate.updateBreakLabel()
        breakTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
    }
    
    func startTimer() {
        totalTime = 12
        
        delegate.updateTimeLabel()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
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
    
    func reset() -> () {
        if (countdownTimer != nil) {
            countdownTimer.invalidate()
        }
        if (breakTimer != nil) {
            breakTimer.invalidate()
        }
        score = 0
        
    }
    
    func endTimer() {
        switch status {
        case .play:
            delegate.isOver()
            status = .over
            save()
            reset()
            
        case .pauseCount, .restartCount:
            breakTimer.invalidate()
            delegate.breakOver()
            
        default:
            break
        }
        
    }
    
}

