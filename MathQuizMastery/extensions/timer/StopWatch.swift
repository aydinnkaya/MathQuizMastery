//
//  stopWatch.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 12.01.2025.
//

import Foundation
import UIKit


/*
 class StopWatch {
 private var timer: Timer?
 private var counter: Int = 60
 weak var delegate: GameScreen?
 
 init(delegate: GameScreen) {
 self.delegate = delegate
 }
 
 func startTimer() {
 counter = 60
 timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
 }
 
 @objc private func updateTimer() {
 counter -= 1
 let minutes = counter / 60
 let seconds = counter % 60
 delegate?.timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
 
 if counter <= 0 {
 timer?.invalidate()
 delegate?.timeUp()
 }
 }
 }
 */
