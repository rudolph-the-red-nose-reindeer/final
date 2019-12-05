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
}

class Model {

    weak var delegate: ModelDelegate!
    static var defaults = UserDefaults.standard
    var caught: Bool = false
    var countdownTimer: Timer!
    var totalTime = 10
    var score: Int = 0
    var formatter: DateFormatter = DateFormatter()
    var status: gameState = .over
    enum gameState{
        case play
        case pause
        case over
    }

    struct gamePlay {
        let date: Date
        let score: Int
    }
    
    var scores = [gamePlay]()

    func startTimer() {
        status = .play
        delegate.updateTimeLabel()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    func endTimer() {
        delegate.isOver()
        status = .over
        save()
        reset()
        countdownTimer.invalidate()
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
        score = 0
    }
    
    
}

