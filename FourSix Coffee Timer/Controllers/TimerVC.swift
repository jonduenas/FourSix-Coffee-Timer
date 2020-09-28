//
//  TimerVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/26/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit
import AVFoundation

class TimerVC: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet var currentStepTimeLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!
    @IBOutlet var currentStepWeightLabel: UILabel!
    @IBOutlet var currentTotalWeightLabel: UILabel!
    @IBOutlet var currentStepLabel: UILabel!
    @IBOutlet var currentStepStackView: UIStackView!
    @IBOutlet var totalTimeStackView: UIStackView!
    
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    @IBOutlet var progressView: ProgressCircle!
    
    let summarySegueID = "ShowSummary"
    var coffeeTimer: CoffeeTimer!
    //var timer: Timer?
    
    
    var isTimerEnd = false
    
    let recipe: Recipe
    
    //var recipeIndex = 0
    var currentWater: Float = 0
    
    private var audioPlayer: AVAudioPlayer?
    
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
        
        if UserDefaultsManager.totalTimeShown {
            totalTimeStackView.isHidden = false
        }
        
        let timerScheduler = TimerScheduler()
        coffeeTimer = CoffeeTimer(timerScheduler: timerScheduler, recipe: recipe)
        
        updateWeightLabels()
        
        initializeSoundFile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UIApplication.shared.isIdleTimerDisabled = false
        if isTimerEnd {
            playSoundWithVibrate()
        }
    }
    
    // MARK: AVAudioPlayer Methods
    
    private func initializeSoundFile() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, options: .duckOthers)
        } catch {
            print(error.localizedDescription)
        }
    
        guard let sound = Bundle.main.path(forResource: "custom-notification", ofType: "mp3") else { return }
        let url = URL(fileURLWithPath: sound)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func activateAudioSession(_ activate: Bool) {
        do {
            try AVAudioSession.sharedInstance().setActive(activate)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func playSoundWithVibrate() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let audioPlayer = self?.audioPlayer else { return }
            self?.activateAudioSession(true)
            audioPlayer.play()
            UIDevice.vibrate()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.activateAudioSession(false)
        }
    }

    // MARK: Button methods
    
    @IBAction func closeTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Do you want to exit the timer?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Exit", style: .default, handler: { [weak self] _ in
            self?.coffeeTimer.cancelTimer()
            self?.dismiss(animated: true)
        }))
        present(alert, animated: true)        
    }
    
    @IBAction func playPauseTapped(_ sender: Any) {
        if coffeeTimer.timerState == .running {
            coffeeTimer.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else if coffeeTimer.timerState == .paused {
            startTimer()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else if coffeeTimer.timerState == .new {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            countdownStart()
        } else {
            print("Error loading coffeeTimer.")
        }
    }
    
    @IBAction func forwardTapped(_ sender: Any) {
        coffeeTimer.nextStep()
    }
    
    // MARK: Update UI methods
    
    private func updateWeightLabels() {
        currentStepLabel.text = "Step \(coffeeTimer.recipeIndex + 1) of \(recipe.waterPours.count)"
        currentStepWeightLabel.text = "Pour " + recipe.waterPours[coffeeTimer.recipeIndex].clean + "g"
        currentTotalWeightLabel.text = currentWater.clean + "g"
    }
    
    func updateTimeLabels(_ currentInterval: TimeInterval, _ totalElapsedTime: TimeInterval) {
        currentStepTimeLabel.text = currentInterval.stringFromTimeInterval()
        totalTimeLabel.text = totalElapsedTime.stringFromTimeInterval()
    }
    
    private func nextStep() {
        playSoundWithVibrate()
        
        progressView.setStrokeColor(for: progressView.progressLayer, to: progressView.progressStrokeColor, animated: true)
        
        currentWater += recipe.waterPours[coffeeTimer.recipeIndex]
        updateWeightLabels()
    }
    
    // MARK: Timer methods
    
    private func startTimer() {
        coffeeTimer.start { [weak self] timerUpdate in
            switch timerUpdate {
            case .tick(step: let stepTime, total: let totalTime):
                self?.runTimer(currentStepElapsedTime: stepTime, totalElapsedTime: totalTime)
            case .nextStep(step: let stepTime, total: let totalTime):
                self?.nextStep()
                self?.updateTimeLabels(stepTime, totalTime)
            case .done:
                self?.endTimer()
            default:
                return
            }
        }
    }
    
    private func startNewTimer() {
        if coffeeTimer.timerState == .new {
            //first run of brand new timer
            
            //disable screen from sleeping while timer being used
            UIApplication.shared.isIdleTimerDisabled = true
            
            startTimer()
            
            playPauseButton.isEnabled = true
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            
            currentWater += recipe.waterPours[coffeeTimer.recipeIndex]
            updateWeightLabels()
            nextButton.isHidden = false
            
            UIView.animate(withDuration: 0.2) {
                self.nextButton.alpha = 1
            }
            playSoundWithVibrate()
        } else {
            print("Attempting to start new timer when timer state is not new.")
        }
    }
    
    private func runTimer(currentStepElapsedTime: TimeInterval, totalElapsedTime: TimeInterval) {
        DispatchQueue.main.async {
            self.updateTimeLabels(currentStepElapsedTime, totalElapsedTime)
            self.updateProgress()
        }
        
        if currentStepElapsedTime > recipe.interval - CoffeeTimer.Constants.timerInterval {
            // User has auto-advance turned off - set color to red for warning
            DispatchQueue.main.async {
                self.progressView.setStrokeColor(for: self.progressView.progressLayer, to: self.progressView.progressOverStrokeColor, animated: true)
            }
        }
    }
    
    func updateProgress() {
        let fromPercentage = coffeeTimer.fromPercentage
        let toPercentage = coffeeTimer.toPercentage
        
        DispatchQueue.main.async {
            if fromPercentage >= 1 {
                self.progressView.progressLayer.strokeEnd = 1
            } else {
                self.progressView.animateProgress(from: fromPercentage, to: toPercentage, duration: CoffeeTimer.Constants.timerInterval)
            }
        }
    }
    
    private func endTimer() {
        isTimerEnd = true
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        performSegue(withIdentifier: summarySegueID, sender: self)
    }
    
    private func countdownStart() {
        playPauseButton.setImage(nil, for: .normal)
        playPauseButton.setTitle("\(coffeeTimer.countdownTime)", for: .normal)
        playPauseButton.setTitleColor(UIColor.systemGray2, for: .normal)
        playPauseButton.contentHorizontalAlignment = .center
        playPauseButton.titleLabel?.font = UIFont.systemFont(ofSize: 38)
        
        coffeeTimer.startCountdownTimer { [weak self] countdownUpdate in
            switch countdownUpdate {
            case .countdown(let countdownTime):
                self?.playPauseButton.setTitle("\(countdownTime)", for: .normal)
            case .done:
                self?.playPauseButton.setTitle(nil, for: .normal)
                self?.playPauseButton.contentHorizontalAlignment = .fill
                self?.startNewTimer()
            default:
                return
            }
        }
    }
    
//    @objc private func countdown() {
//        if startCountdown > 1 {
//            startCountdown -= 1
//            playPauseButton.setTitle("\(startCountdown)", for: .normal)
//        } else {
//            if let timer = self.timer {
//                timer.invalidate()
//                self.timer = nil
//                playPauseButton.setTitle(nil, for: .normal)
//                playPauseButton.contentHorizontalAlignment = .fill
//                coffeeTimer.timerState = .new
//                startNewTimer()
//            }
//        }
//    }
    
    // MARK: Navigation Methods
    
    @IBSegueAction
    func showSummaryVC(coder: NSCoder) -> UIViewController? {
        BrewSummaryVC(coder: coder, recipe: recipe, drawdownTimes: coffeeTimer.stepsActualTime, totalTime: coffeeTimer.totalElapsedTime)
    }
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
}
