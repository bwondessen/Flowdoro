//
//  HomeViewModel.swift
//  Flowdoro
//
//  Created by Bruke on 10/24/22.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var timerPaused: Bool = true
    
    @Published var focusTime: Double = 5
    @Published var focusTimeRemaining: Double = 5
    @Published var flowTime: Double = 4
    @Published var flowTimeRemaining: Double = 4
    @Published var breakTime: Double = 3
    @Published var breakTimeRemaining: Double = 3
    @Published var flowdoroCycle: Int = 0
    
    @Published var inFocus: Bool = true
    @Published var inFlow: Bool = false
    @Published var inBreak: Bool = false

    @Published var counter: Int = 0
    
    // Timer
    func startTimer() {
        timerPaused = false
        self.timer  = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func pauseTimer() {
        timerPaused = true
        self.timer.upstream.connect().cancel()
    }
    
    func endTimer() {
        pauseTimer()
        focusTimeRemaining = focusTime
        flowTimeRemaining = flowTime
        breakTimeRemaining = breakTime
        counter = 0
    }
    
    func resetCycle() {
        pauseTimer()
        inFocus = true
        inFlow = false
        inBreak = false
        focusTimeRemaining = focusTime
        flowTimeRemaining = flowTime
        breakTimeRemaining = breakTime
        counter = 0
    }
    
    func timeRemainingInPercent() -> Double {
        guard
            focusTimeRemaining >= 0,
            flowTimeRemaining >= 0
        else { return 0 }
        
        if inFocus {
            return Double(counter) / focusTime
        } else if inFlow {
            return Double(counter) / flowTime
        } else {
            return Double(counter) / breakTime
        }
    }
    
    func incrementCounter() -> Int {
        if counter <= Int(focusTime) - 1 {
            counter += 1
        }
        return counter
    }
}