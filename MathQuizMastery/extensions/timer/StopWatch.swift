//
//  stopWatch.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 12.01.2025.
//

import Foundation
import UIKit


class StopWatch {
    
    var timer : Timer = Timer()
    var counter : Int = 60
    var timeCounting : Bool = false
    var timeString : String = ""
    var timerLabelText : String?
    var gameScreen : GameScreen?
    
    init(gameScreen: GameScreen? = nil) {
        self.gameScreen = gameScreen
    }
    
    func startTimer() {
        if timeCounting{
            return
        }
        timeCounting = true
        counter = 60
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeCounter), userInfo: nil, repeats: true)
        
        let time = secondsToMinutesSeconds(seconds: counter)
        let timeString = makeTimeString(minutes: time.0, seconds: time.1)
        gameScreen?.updateTimeLabel(timeString: timeString)
    }
    
    
    @objc func timeCounter() -> Void {
        counter -= 1
        let time = secondsToMinutesSeconds(seconds: counter) // Tuple
        let timeString = makeTimeString(minutes: time.0, seconds: time.1)
        gameScreen?.updateTimeLabel(timeString: timeString)
        
        if counter <= 0 {
            timer.invalidate()
            gameScreen?.timeUp()
        }
    }
    
    func secondsToMinutesSeconds(seconds : Int) -> (Int, Int){
        return (((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    func makeTimeString(minutes : Int, seconds : Int) -> String {
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}
