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
    
    private enum Constants {
        static let timerInterval: TimeInterval = 0.25
    }

    @IBOutlet var currentStepTimeLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!
    @IBOutlet var currentStepWeightLabel: UILabel!
    @IBOutlet var currentTotalWeightLabel: UILabel!
    @IBOutlet var currentStepLabel: UILabel!
    @IBOutlet var currentStepStackView: UIStackView!
    
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    @IBOutlet var progressView: ProgressCircle!
    
    let coffeeTimer = CoffeeTimer()
    var timer: Timer?
    var stepsActualTime = [TimeInterval]()
    var startCountdown = 3
    
    let recipe: Recipe
    
    var recipeIndex = 0
    var currentWater: Float = 0
    
    var chimeNotification: AVAudioPlayer?
    
    init?(coder: NSCoder, recipe: Recipe) {
        self.recipe = recipe
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearNavigationBar()
        
        //make timer font monospaced
        currentStepTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 80, weight: .light)
        totalTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 35, weight: .light)
        
        updateWeightLabels()
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
            timer?.invalidate()
            timer = nil
    
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else if coffeeTimer.timerState == .paused {
            //resume paused timer
            coffeeTimer.start()
            startTimer()

            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else if coffeeTimer.timerState == .new {
            countdownStart()
        } else {
            print("Error loading coffeeTimer.")
        }
    }
    
    @IBAction func forwardTapped(_ sender: Any) {
        if recipeIndex < recipe.waterPours.count - 1 {
            nextStep()
        } else {
            endTimer()
        }
    }
    
    // MARK: Update UI methods
    
    private func updateWeightLabels() {
        currentStepLabel.text = "Step \(recipeIndex + 1) of \(recipe.waterPours.count)"
        currentStepWeightLabel.text = "Pour " + recipe.waterPours[recipeIndex].clean + "g"
        currentTotalWeightLabel.text = currentWater.clean + "g"
    }
    
    private func updateTimeLabels(_ currentInterval: TimeInterval, _ totalElapsedTime: TimeInterval) {
        currentStepTimeLabel.text = currentInterval.stringFromTimeInterval()
        totalTimeLabel.text = totalElapsedTime.stringFromTimeInterval()
    }
    
    private func nextStep() {
        playAudioNotification()
        stepsActualTime.append(coffeeTimer.currentStepElapsedTime)

        coffeeTimer.nextStep()
        
        recipeIndex += 1
        
        currentWater += recipe.waterPours[recipeIndex]
        updateWeightLabels()
    }
    
    private func showEndAC() {
        let averageStepTime = stepsActualTime.reduce(0, +) / Double(stepsActualTime.count)
        
        let ac = UIAlertController(title: "Done!", message: "Total time elapsed was \(coffeeTimer.totalElapsedTime.stringFromTimeInterval()).\nAverage time for each step was \(averageStepTime.stringFromTimeInterval()).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }))
        present(ac, animated: true)
    }
    
    // MARK: Timer methods
    
    private func startNewTimer() {
        if coffeeTimer.timerState == .new {
            //first run of brand new timer
            
            //disable screen from sleeping while timer being used
            UIApplication.shared.isIdleTimerDisabled = true
            
            coffeeTimer.start()
            startTimer()
            
            playPauseButton.isEnabled = true
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            
            currentWater += recipe.waterPours[recipeIndex]
            updateWeightLabels()
            nextButton.isHidden = false
            
            UIView.animate(withDuration: 0.2) {
                self.nextButton.alpha = 1
            }
            
            playAudioNotification()
        } else {
            print("Attempting to start new timer when timer state is not new.")
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: Constants.timerInterval, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func runTimer() {
        coffeeTimer.runCoffeeTimer()
        
        if coffeeTimer.currentStepElapsedTime < recipe.interval {
            updateTimeLabels(coffeeTimer.currentStepElapsedTime, coffeeTimer.totalElapsedTime)
            
            updateProgress()
        } else {
            //check if end of recipe
            if recipeIndex < recipe.waterPours.count - 1 {
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
    
    private func updateProgress() {
        let fromPercentage = coffeeTimer.fromPercentage
        let toPercentage = coffeeTimer.toPercentage
        
        progressView.animateProgress(from: fromPercentage, to: toPercentage, duration: Constants.timerInterval)
    }
    
    private func endTimer() {
        playAudioNotification()
        
        timer?.invalidate()
        timer = nil
        UIApplication.shared.isIdleTimerDisabled = false
        
        showEndAC()
    }
    
    func playAudioNotification() {
        let path = Bundle.main.path(forResource: "custom-notification.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)

        do {
            chimeNotification = try AVAudioPlayer(contentsOf: url)
            chimeNotification?.play()
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func countdownStart() {
        coffeeTimer.timerState = .countdown
        playPauseButton.setImage(nil, for: .normal)
        playPauseButton.setTitle("\(startCountdown)", for: .normal)
        playPauseButton.setTitleColor(UIColor(named: "Accent"), for: .normal)
        playPauseButton.contentHorizontalAlignment = .center
        playPauseButton.titleLabel?.font = UIFont.systemFont(ofSize: 38)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    
    @objc private func countdown() {
        if startCountdown > 1 {
            startCountdown -= 1
            playPauseButton.setTitle("\(startCountdown)", for: .normal)
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
                playPauseButton.setTitle(nil, for: .normal)
                playPauseButton.contentHorizontalAlignment = .fill
                coffeeTimer.timerState = .new
                startNewTimer()
            }
        }
    }
}
