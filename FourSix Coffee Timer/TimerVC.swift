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
    
    @IBOutlet var centerView: UIView!
    
    var timer = Timer()
    var timerState: TimerState?
    var startTime: Date?
    var endTime: Date?
    var totalTime: TimeInterval?
    var currentStepEndTime: Date?
    var pausedTime: Date?
    var pausedIntervals = [TimeInterval]()
    var stepsTime = TimeInterval()
    
    var recipeWater = [Double]()
    var recipeInterval: TimeInterval = 0
    var recipeIndex = 0
    var totalWater: Double = 0
    var totalCoffee: Double = 0
    var currentWater: Double = 0
    
    let shapeLayer = CAShapeLayer()
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")

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
        recipeInterval = 45
        totalCoffee = 20
        totalTime = recipeInterval * Double(recipeWater.count)
        
        ratioLabel.text = "\(totalCoffee)g coffee : \(totalWater)g water"
        nextStepLabel.isHidden = true
        currentStepLabel.text = "Pour \(recipeWater[0])g"
        currentWeightLabel.text = "\(currentWater)g"
        currentStepTimeLabel.text = recipeInterval.stringFromTimeInterval()
        totalTimeLabel.text = totalTime?.stringFromTimeInterval()
    }
    
    override func viewDidLayoutSubviews() {
        //circle progress indicator
        createProgressBar()
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
        if timerState == .running {
            //pause timer
            pauseAnimation()
            timer.invalidate()
            timerState = .paused
            pausedTime = Date()
            playPauseButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
        } else if timerState == .paused {
            //resume paused timer
            guard let pause = pausedTime else { return }
            let pausedInterval = Date().timeIntervalSince(pause)
            startTime = startTime?.addingTimeInterval(pausedInterval)
            endTime = endTime?.addingTimeInterval(pausedInterval)
            currentStepEndTime = currentStepEndTime?.addingTimeInterval(pausedInterval)
            pausedTime = nil
            startTimer()
            resumeAnimation()
            timerState = .running
            playPauseButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
        } else {
            //first run of brand new timer
            startTimer()
            startProgressBar()
            startTime = Date()
            if let totalTime = totalTime {
                endTime = startTime?.addingTimeInterval(totalTime)
            }
            currentStepEndTime = Date().addingTimeInterval(recipeInterval)
            timerState = .running
            playPauseButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            
            currentWater += recipeWater[recipeIndex]
            currentWeightLabel.text = "\(currentWater)g"
        }
        
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
    }
    
    @objc func runTimer() {
        let currentTime = Date()
        
        guard let totalTimeLeft = endTime?.timeIntervalSince(currentTime).rounded() else { return }
        
        guard let currentInterval = currentStepEndTime?.timeIntervalSince(currentTime).rounded() else { return }
        
        //current step end
        if currentInterval <= 0 {
            //check if end of recipe
            if recipeIndex < recipeWater.count - 1 {
                //move to next step
                totalTimeLabel.text = totalTimeLeft.stringFromTimeInterval()
                currentStepEndTime = Date().addingTimeInterval(recipeInterval)
                startProgressBar()
                currentStepTimeLabel.text = recipeInterval.stringFromTimeInterval()
                stepsTime += recipeInterval
                recipeIndex += 1
                currentWater += recipeWater[recipeIndex]
                currentWeightLabel.text = "\(currentWater)g"
                currentStepLabel.text = "Pour \(recipeWater[recipeIndex])g"
            } else {
                //last step
                currentStepTimeLabel.text = "00:00"
                totalTimeLabel.text = "00:00"
                timer.invalidate()
                let ac = UIAlertController(title: "Done!", message: "Enjoy your coffee.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                    self?.dismiss(animated: true)
                }))
                present(ac, animated: true)
            }
        } else {
            //update time labels
            currentStepTimeLabel.text = currentInterval.stringFromTimeInterval()
            totalTimeLabel.text = totalTimeLeft.stringFromTimeInterval()
        }
        
    }
    
    func createProgressBar() {
        let center = centerView.convert(centerView.center, from: centerView.superview)
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 140, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true)
        
        //create track layer
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.systemGray2.cgColor
        trackLayer.lineWidth = 10
        trackLayer.position = center
        
        centerView.layer.addSublayer(trackLayer)
        
        //create progress layer
        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor(named: "Accent")?.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.position = center
        //shapeLayer.transform = CATransform3DMakeRotation(-90.degreesToRadians, 0, 0, 1)
        
        centerView.layer.addSublayer(shapeLayer)
    }
    
    func startProgressBar() {
        basicAnimation.fromValue = 1
        basicAnimation.toValue = 0
        basicAnimation.duration = recipeInterval
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "circleAnimation")
    }
    
    func pauseAnimation() {
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0.0
        shapeLayer.timeOffset = pausedTime
    }

    func resumeAnimation() {
        let pausedTime = shapeLayer.timeOffset
        shapeLayer.speed = 1
        shapeLayer.timeOffset = 0
        shapeLayer.beginTime = 0
        let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shapeLayer.beginTime = timeSincePause
    }
}

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}

extension TimeInterval{

    func stringFromTimeInterval() -> String {

        let time = NSInteger(self)

        let seconds = time % 60
        let minutes = (time / 60) % 60

        return String(format: "%0.2d:%0.2d",minutes,seconds)

    }
}
