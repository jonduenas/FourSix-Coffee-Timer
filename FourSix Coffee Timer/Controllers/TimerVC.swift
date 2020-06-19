//
//  TimerVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/26/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit
import AVFoundation

enum TimerState {
    case new
    case running
    case paused
}

class TimerVC: UIViewController {

    @IBOutlet var currentStepTimeLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!
    @IBOutlet var currentStepLabel: UILabel!
    @IBOutlet var currentWeightLabel: UILabel!
    
    @IBOutlet var playPauseButton: UIButton!
    
    @IBOutlet var progressView: UIView!
    
    var timer: Timer?
    var timerState: TimerState?
    var startTime: Date!
    var endTime: Date!
    var totalTime: TimeInterval!
    var currentStepStartTime: Date!
    var currentStepEndTime: Date!
    var pausedTime: Date!
    var stepsTime = TimeInterval()
    var stepsActualTime = [TimeInterval]()
    
    var totalElapsedTime: TimeInterval = 0
    var currentStepElapsedTime: TimeInterval = 0
    
    var totalTimeLeft: TimeInterval = 0
    var currentStepTimeLeft: TimeInterval = 0
    
    var recipeWater = [Double]()
    var recipeInterval: TimeInterval = 0
    var recipeIndex = 0
    var totalWater: Double = 0
    var totalCoffee: Double = 0
    var currentWater: Double = 0
    
    var progressLayer: CAShapeLayer!
    var trackLayer: CAShapeLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //remove shadow from navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        //make timer font monospaced
        currentStepTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 80, weight: .light)
        totalTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 35, weight: .light)
        
        //setup for new timer
        timerState = .new
        
        //setup recipe
        if recipeInterval == 0 {
            recipeInterval = 45
        }
        
        if totalCoffee == 0 {
            totalCoffee = 20
        }
        
        if recipeWater.isEmpty {
            recipeWater = [60, 60, 60, 60, 60]
        }
        
        totalTime = recipeInterval * Double(recipeWater.count)
        
        //updateWeightLabels()
        //currentStepTimeLabel.text = recipeInterval.stringFromTimeInterval()
        //totalTimeLabel.text = totalTime?.stringFromTimeInterval()
        
        createProgressBar()
    }
    
    override func viewDidLayoutSubviews() {
        layoutProgressBar()
    }

    // MARK: Button methods
    
    @IBAction func xTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Do you want to exit the timer?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Exit", style: .default, handler: { [weak self] _ in
            self?.timer?.invalidate()
            self?.timer = nil
            UIApplication.shared.isIdleTimerDisabled = false
            self?.dismiss(animated: true)
        }))
        present(ac, animated: true)        
    }
    
    @IBAction func playPauseTapped(_ sender: Any) {
        if timerState == .running {
            //pause timer
            print("Paused")
            pauseAnimation()
            timer?.invalidate()
            timer = nil
            timerState = .paused
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else if timerState == .paused {
            //resume paused timer
            print("Resume")
            //endTime = Date().addingTimeInterval(totalTimeLeft)
            startTime = Date().addingTimeInterval(totalElapsedTime)
            //currentStepEndTime = Date().addingTimeInterval(currentStepTimeLeft)
            currentStepStartTime = Date().addingTimeInterval(currentStepElapsedTime)
            startTimer()
            resumeAnimation()
            timerState = .running
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            //first run of brand new timer
            print("Start")
            
            //disable screen from sleeping while timer being used
            UIApplication.shared.isIdleTimerDisabled = true
            
            startTimer()
            startProgressBar()
            startTime = Date()
            endTime = startTime.addingTimeInterval(totalTime)
            currentStepStartTime = Date()
            currentStepEndTime = currentStepStartTime.addingTimeInterval(recipeInterval)
            timerState = .running
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            
            currentWater += recipeWater[recipeIndex]
            updateWeightLabels()
        }
    }
    
    @IBAction func forwardTapped(_ sender: Any) {
        
        if recipeIndex < recipeWater.count - 1 {
            nextStep()
        } else {
            endTimer()
        }
        
    }
    
    // MARK: Update UI methods
    
    func updateWeightLabels() {
        currentStepLabel.text = "Pour " + recipeWater[recipeIndex].clean + "g"
        currentWeightLabel.text = currentWater.clean + "g"
    }
    
    fileprivate func updateTimeLabels(_ currentInterval: TimeInterval, _ totalTimeElapsed: TimeInterval) {
        //update time labels
        currentStepTimeLabel.text = currentInterval.stringFromTimeInterval()
        totalTimeLabel.text = totalTimeElapsed.stringFromTimeInterval()
    }
    
    fileprivate func nextStep() {
        playAudioNotification()
        stepsActualTime.append(currentStepElapsedTime)
        currentStepTimeLabel.text = "00:00"
        currentStepStartTime = Date()
        currentStepEndTime = currentStepStartTime.addingTimeInterval(recipeInterval)
        startProgressBar()
        recipeIndex += 1
        currentWater += recipeWater[recipeIndex]
        updateWeightLabels()
    }
    
    // MARK: Timer methods
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
    }
    
    @objc func runTimer() {
        let currentTime = Date()
        
        //totalTimeLeft = round(endTime.timeIntervalSince(currentTime))
        totalElapsedTime = -round(startTime.timeIntervalSince(currentTime))
        
        //currentStepTimeLeft = round(currentStepEndTime.timeIntervalSince(currentTime))
        currentStepElapsedTime = -round(currentStepStartTime.timeIntervalSince(currentTime))
        
//        print("Total - \(endTime.timeIntervalSince(currentTime)) / " + totalTimeLeft.stringFromTimeInterval())
//        print("Step - \(currentStepEndTime.timeIntervalSince(currentTime)) / " + currentStepTimeLeft.stringFromTimeInterval())
        
        //if currentStepTimeLeft <= 0 { //end of current step
        if currentStepElapsedTime >= recipeInterval {
        //check if end of recipe
            if recipeIndex < recipeWater.count - 1 {
                //move to next step
                totalTimeLabel.text = totalElapsedTime.stringFromTimeInterval()
                nextStep()
            } else {
                //last step
                updateTimeLabels(currentStepElapsedTime, totalElapsedTime)
                endTimer()
            }
        } else {
            updateTimeLabels(currentStepElapsedTime, totalElapsedTime)
        }
    }
    
    fileprivate func endTimer() {
        playAudioNotification()
        pauseAnimation()
        timer?.invalidate()
        timer = nil
        UIApplication.shared.isIdleTimerDisabled = false
        
        let averageStepTime = stepsActualTime.reduce(0, +) / Double(stepsActualTime.count)
        
        let ac = UIAlertController(title: "Done!", message: "Total time elapsed was \(totalElapsedTime.stringFromTimeInterval()).\nAverage time for each step was \(averageStepTime.stringFromTimeInterval()).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }))
        present(ac, animated: true)
    }
    
    func playAudioNotification() {
        AudioServicesPlaySystemSound(SystemSoundID(1322))
    }
    
    // MARK: Progress Circle Methods
    
    func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 140, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true)
        
        layer.path = circularPath.cgPath
        layer.fillColor = fillColor.cgColor
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 10
        layer.strokeEnd = 1
        layer.lineCap = CAShapeLayerLineCap.round
        
        return layer
    }
    
    func createProgressBar() {
        //create track layer
        trackLayer = createCircleShapeLayer(strokeColor: .systemGray2, fillColor: .clear)
        
        progressView.layer.addSublayer(trackLayer)
        
        //create progress layer
        progressLayer = createCircleShapeLayer(strokeColor: UIColor(named: "Accent")!, fillColor: .clear)
        
        progressView.layer.addSublayer(progressLayer)
    }
    
    fileprivate func layoutProgressBar() {
        let center = progressView.convert(progressView.center, from: progressView.superview)
        position(circle: progressLayer, at: center)
        position(circle: trackLayer, at: center)
    }
    
    func position(circle: CAShapeLayer, at center: CGPoint) {
        circle.position = center
    }
    
    func startProgressBar() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.fromValue = 1
        basicAnimation.toValue = 0
        basicAnimation.duration = recipeInterval
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        self.progressLayer.add(basicAnimation, forKey: "circleAnimation")
    }
    
    func pauseAnimation() {
        let pausedTime = progressLayer.convertTime(CACurrentMediaTime(), from: nil)
        progressLayer.speed = 0.0
        progressLayer.timeOffset = pausedTime
    }

    func resumeAnimation() {
        let pausedTime = progressLayer.timeOffset
        progressLayer.speed = 1
        progressLayer.timeOffset = 0
        progressLayer.beginTime = 0
        let timeSincePause = progressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        progressLayer.beginTime = timeSincePause
    }
}

// MARK: Extensions

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}

extension TimeInterval{

    func stringFromTimeInterval() -> String {

        let time = NSInteger(abs(self))

        let seconds = time % 60
        let minutes = (time / 60) % 60

        return String(format: "%0.2d:%0.2d",minutes,seconds)

    }
}
