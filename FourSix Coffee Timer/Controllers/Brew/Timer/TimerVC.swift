//
//  TimerVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/26/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit
import AVFoundation

class TimerVC: UIViewController, Storyboarded {
    var coffeeTimer: CoffeeTimer!
    var recipe: Recipe!
    private var audioPlayer: AVAudioPlayer?
    weak var coordinator: TimerCoordinator?
    private var currentWater: Float = 0
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavBar()
        initTimerFonts()
        initTimerUserPreferences()
        initCoffeeTimer()
        updateWeightLabels()
        initSoundFile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    private func initNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeTapped))
    }
    
    private func initTimerFonts() {
        // Make timer font monospaced
        currentStepTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 80, weight: .light)
        totalTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 35, weight: .light)
    }
    
    private func initTimerUserPreferences() {
        totalTimeStackView.isHidden = !UserDefaultsManager.totalTimeShown
    }
    
    private func initCoffeeTimer() {
        let timerScheduler = TimerScheduler()
        coffeeTimer = CoffeeTimer(timerScheduler: timerScheduler, recipe: recipe)
    }

    // MARK: Button methods
    
    @objc func closeTapped() {
        AlertHelper.showCancellableAlert(title: "Do you want to exit the timer?",
                                         message: nil,
                                         confirmButtonTitle: "Exit",
                                         dismissButtonTitle: "Cancel",
                                         on: self,
                                         confirmHandler: { [weak self] _ in
                                            self?.coffeeTimer.cancelTimer()
                                            self?.dismiss(animated: true, completion: {
                                                self?.coordinator?.didCancelTimer()
                                            })
                                         })
    }
    
    @IBAction func playPauseTapped(_ sender: Any) {
        switch coffeeTimer.timerState {
        case .running:
            coffeeTimer.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        case .paused:
            startTimer()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        case .countdown:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            countdownStart()
        default:
            print("Error loading coffeeTimer.")
        }
    }
    
    @IBAction func forwardTapped(_ sender: Any) {
        coffeeTimer.nextStep(auto: false)
    }
    
    // MARK: Update UI methods
    
    private func updateWeightLabels() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.currentStepLabel.text = "Step \(self.coffeeTimer.recipeIndex + 1) of \(self.recipe.waterPours.count)"
            self.currentStepWeightLabel.text = "Pour " + self.recipe.waterPours[self.coffeeTimer.recipeIndex].clean + "g"
            self.currentTotalWeightLabel.text = self.currentWater.clean + "g"
        }
    }
    
    func updateTimeLabels(_ currentInterval: TimeInterval, _ totalElapsedTime: TimeInterval) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.currentStepTimeLabel.text = currentInterval.stringFromTimeInterval()
            self.totalTimeLabel.text = totalElapsedTime.stringFromTimeInterval()
        }
    }
    
    private func nextStep() {
        playSoundWithVibrate()
        
        currentWater += recipe.waterPours[coffeeTimer.recipeIndex]
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.updateWeightLabels()
        }
    }
    
    // MARK: Timer methods
    
    private func startTimer() {
        coffeeTimer.start { [weak self] timerUpdate in
            switch timerUpdate {
            case .tick(step: let stepTime, total: let totalTime):
                self?.runTimer(currentStepElapsedTime: stepTime, totalElapsedTime: totalTime)
            case .nextStep(step: let stepTime, total: let totalTime):
                self?.nextStep()
                self?.runTimer(currentStepElapsedTime: stepTime, totalElapsedTime: totalTime)
            case .done:
                self?.endTimer()
            default:
                print("Error with timer.")
            }
        }
    }
    
    private func startNewTimer() {
        // First run of brand new timer
        guard coffeeTimer.timerState == .new else {
            print("Attempting to start new timer when timer state is not new.")
            return
        }
        
        // Disable screen from sleeping while timer being used
        UIApplication.shared.isIdleTimerDisabled = true
        
        startTimer()
        playSoundWithVibrate()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.playPauseButton.isEnabled = true
            self.playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            
            self.currentWater += self.recipe.waterPours[self.coffeeTimer.recipeIndex]
            self.updateWeightLabels()
            
            self.nextButton.isHidden = false
            
            UIView.animate(withDuration: 0.2) {
                self.nextButton.alpha = 1
            }
        }
    }
    
    private func runTimer(currentStepElapsedTime: TimeInterval, totalElapsedTime: TimeInterval) {
        DispatchQueue.main.async {
            self.updateTimeLabels(currentStepElapsedTime, totalElapsedTime)
            self.updateProgress()
        }
        
        let isPastInterval = currentStepElapsedTime > recipe.interval + CoffeeTimer.Constants.timerInterval
        let progressStrokeColorIsWarning = progressView.progressLayer.strokeColor == progressView.progressWarningStrokeColor.cgColor
        
        if isPastInterval {
            guard !progressStrokeColorIsWarning else { return } // Makes sure color isn't already set for warning
            
            // User has auto-advance turned off - set color for warning
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }

                self.progressView.setStrokeColor(for: self.progressView.progressLayer, to: self.progressView.progressWarningStrokeColor, animated: true)
            }
        } else {
            guard progressStrokeColorIsWarning else { return } // Makes sure color is set to warning before changing it back
            
            DispatchQueue.main.async {
                self.progressView.setStrokeColor(for: self.progressView.progressLayer, to: self.progressView.progressStrokeColor, animated: false)
            }
        }
    }
    
    func updateProgress() {
        let fromPercentage = coffeeTimer.fromPercentage
        let toPercentage = coffeeTimer.toPercentage
        
        DispatchQueue.main.async {
            self.progressView.animateProgress(from: fromPercentage, to: toPercentage, duration: CoffeeTimer.Constants.timerInterval)
        }
    }
    
    private func endTimer() {
        playSoundWithVibrate()
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        let session = Session(drawdownTimes: coffeeTimer.stepsActualTime, totalTime: coffeeTimer.totalElapsedTime)
        
        coordinator?.didFinishTimer(session: session, recipe: recipe)
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
}

extension TimerVC: AVAudioPlayerDelegate {
    private func initSoundFile() {
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
            guard let self = self else { return }
            guard let audioPlayer = self.audioPlayer else { return }
            self.activateAudioSession(true)
            audioPlayer.play()
            UIDevice.vibrate()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.activateAudioSession(false)
        }
    }
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
}
