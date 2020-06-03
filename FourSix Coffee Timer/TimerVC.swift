//
//  TimerVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/26/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

enum TimerState {
    case new
    case running
    case paused
}

class TimerVC: UIViewController {

    @IBOutlet var ratioLabel: UILabel!
    @IBOutlet var currentStepTimeLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!
    @IBOutlet var currentStepLabel: UILabel!
    @IBOutlet var currentWeightLabel: UILabel!
    @IBOutlet var nextStepLabel: UILabel!
    
    @IBOutlet var playPauseButton: UIButton!
    
    var timer = Timer()
    var timerState: TimerState?
    var startTime = TimeInterval()
    var pausedTime: Date?
    var pausedIntervals = [TimeInterval]()
    
    var recipeWater = [Int]()
    var recipeTime = [Double]()
    var recipeIntervals = [Double]()
    var recipeIndex = 0
    var totalWater = 0
    var totalCoffee = 0
    var currentWater = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //remove shadow from navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        //make timer font monospaced
        currentStepTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 70, weight: .light)
        totalTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 30, weight: .light)
        
        //setup for new timer
        timerState = .new
        
        //setup recipe
        recipeTime = [45, 90, 135, 180, 225]
        recipeIntervals = [0, 45, 90, 135, 180]
        recipeWater = [50, 70, 60, 60, 60]
        totalWater = 300
        totalCoffee = 20
        
        ratioLabel.text = "\(totalCoffee)g coffee : \(totalWater)g water"
        nextStepLabel.isHidden = true
        currentStepLabel.text = "Pour \(recipeWater[0])g"
        currentWeightLabel.text = "\(currentWater)g"
    }
    
    @IBAction func xTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Do you want to exit the timer?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Exit", style: .default, handler: { [weak self] _ in
            self?.timer.invalidate()
            self?.dismiss(animated: true)
        }))
        present(ac, animated: true)        
    }
    
    @IBAction func playPauseTapped(_ sender: Any) {
        if timerState == .new {
            //start new timer
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
            timerState = .running
            playPauseButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            
            currentWater += recipeWater[recipeIndex]
            currentWeightLabel.text = "\(currentWater)g"
        } else if timerState == .running {
            //pause timer
            timer.invalidate()
            timerState = .paused
            pausedTime = Date()
            playPauseButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
        } else if timerState == .paused {
            //resume paused timer
            let pausedInterval = Date().timeIntervalSince(pausedTime!)
            pausedIntervals.append(pausedInterval)
            pausedTime = nil
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
            timerState = .running
            playPauseButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
        }
        
    }
    
    @IBAction func nextTapped(_ sender: Any) {
    }
    
    
    @IBAction func previousTapped(_ sender: Any) {
    }
    
    @objc func runTimer() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        //calculate total paused time
        var pausedSeconds = pausedIntervals.reduce(0) { $0 + $1 }
        if let pausedTime = pausedTime {
            pausedSeconds += Date().timeIntervalSince(pausedTime)
        }
        
        let totalElapsedTime: TimeInterval = currentTime - startTime - pausedSeconds
        
        if totalElapsedTime <= recipeTime[recipeIndex] {
            let currentElapsedTime = totalElapsedTime - recipeIntervals[recipeIndex]
            
            currentStepTimeLabel.text = format(time: currentElapsedTime)
            totalTimeLabel.text = format(time: totalElapsedTime)
        } else if totalElapsedTime > recipeTime[recipeIndex] {
            let currentElapsedTime = totalElapsedTime - recipeIntervals[recipeIndex]

            currentStepTimeLabel.text = format(time: currentElapsedTime)
            totalTimeLabel.text = format(time: totalElapsedTime)

            if recipeIndex < recipeTime.count - 1 {
                recipeIndex += 1
                currentWater += recipeWater[recipeIndex]
                currentWeightLabel.text = "\(currentWater)g"
                currentStepLabel.text = "Pour \(recipeWater[recipeIndex])g"
            } else if recipeIndex == recipeTime.count - 1 {
                //last step
                timer.invalidate()
                let ac = UIAlertController(title: "Done!", message: "Enjoy your coffee.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                    self?.dismiss(animated: true)
                }))
                present(ac, animated: true)
            }
        }
    }
    
    func format(time: TimeInterval) -> String {
        let formater = DateFormatter()
        formater.dateFormat = "mm:ss.SS"
        
        let date = Date(timeIntervalSinceReferenceDate: time)
        return formater.string(from: date)
    }
}
