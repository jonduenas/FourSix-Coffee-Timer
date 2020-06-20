//
//  TimerVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/26/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit
import AVFoundation

class TimerVC: UIViewController {

    @IBOutlet var currentStepTimeLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!
    @IBOutlet var currentStepLabel: UILabel!
    @IBOutlet var currentWeightLabel: UILabel!
    
    @IBOutlet var playPauseButton: UIButton!
    
    @IBOutlet var progressView: UIView!
    
    let coffeeTimer = CoffeeTimer()
    var timer: Timer?
    var stepsActualTime = [TimeInterval]()
    
    var recipeWater = [Double]()
    var recipeInterval: TimeInterval = 45
    var recipeIndex = 0
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
        if coffeeTimer.timerState == .running {
            //pause timer
            coffeeTimer.pause()
            pauseAnimation()
            timer?.invalidate()
            timer = nil
    
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else if coffeeTimer.timerState == .paused {
            //resume paused timer
            coffeeTimer.start()
            startTimer()
            resumeAnimation()

            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            //first run of brand new timer
            
            //disable screen from sleeping while timer being used
            UIApplication.shared.isIdleTimerDisabled = true
            
            coffeeTimer.start()
            startTimer()
            startProgressBar()
            
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            
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
        currentWater += recipeWater[recipeIndex]
        currentStepLabel.text = "Pour " + recipeWater[recipeIndex].clean + "g"
        currentWeightLabel.text = currentWater.clean + "g"
    }
    
    fileprivate func updateTimeLabels(_ currentInterval: TimeInterval, _ totalElapsedTime: TimeInterval) {
        currentStepTimeLabel.text = currentInterval.stringFromTimeInterval()
        totalTimeLabel.text = totalElapsedTime.stringFromTimeInterval()
    }
    
    fileprivate func nextStep() {
        playAudioNotification()
        stepsActualTime.append(coffeeTimer.currentStepElapsedTime)
        currentStepTimeLabel.text = "00:00"
        coffeeTimer.nextStep()
        startProgressBar()
        recipeIndex += 1
        
        updateWeightLabels()
    }
    
    fileprivate func showEndAC() {
        let averageStepTime = stepsActualTime.reduce(0, +) / Double(stepsActualTime.count)
        
        let ac = UIAlertController(title: "Done!", message: "Total time elapsed was \(coffeeTimer.totalElapsedTime.stringFromTimeInterval()).\nAverage time for each step was \(averageStepTime.stringFromTimeInterval()).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }))
        present(ac, animated: true)
    }
    
    // MARK: Timer methods
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
    }
    
    @objc func runTimer() {
        coffeeTimer.runCoffeeTimer()
        
        if coffeeTimer.currentStepElapsedTime < recipeInterval {
            updateTimeLabels(coffeeTimer.currentStepElapsedTime, coffeeTimer.totalElapsedTime)
        } else {
            //check if end of recipe
            if recipeIndex < recipeWater.count - 1 {
                //move to next step
                totalTimeLabel.text = coffeeTimer.totalElapsedTime.stringFromTimeInterval()
                nextStep()
            } else {
                //last step
                updateTimeLabels(coffeeTimer.currentStepElapsedTime, coffeeTimer.totalElapsedTime)
                endTimer()
            }
        }
    }
    
    
    fileprivate func endTimer() {
        playAudioNotification()
        pauseAnimation()
        timer?.invalidate()
        timer = nil
        UIApplication.shared.isIdleTimerDisabled = false
        
        showEndAC()
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
