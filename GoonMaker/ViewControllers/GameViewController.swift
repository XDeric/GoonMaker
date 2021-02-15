//
//  ViewController.swift
//  GoonMaker
//
//  Created by EricM on 2/12/21.
//

import UIKit

class GameViewController: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var slider3: UISlider!
    @IBOutlet weak var slider4: UISlider!
    @IBOutlet weak var sliderStackView: UIStackView!
    @IBOutlet weak var startTimerButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var breathingButtonBoundary: UIView!
    @IBOutlet weak var breathingButton: UIButton!
    
    //MARK:- Variable and Constants
    //Score
    var slider1MaxValue: Float = 0.0 {
        didSet {
            animateSliderImage(slider: slider1)
            checkSliderValue(slider: slider1)
        }
    }
    var slider2MaxValue: Float = 0.0 {
        didSet {
            animateSliderImage(slider: slider2)
            checkSliderValue(slider: slider2)
        }
    }
    var slider3MaxValue: Float = 0.0 {
        didSet {
            animateSliderImage(slider: slider3)
            checkSliderValue(slider: slider3)
        }
    }
    var slider4MaxValue: Float = 0.0 {
        didSet {
            animateSliderImage(slider: slider4)
            checkSliderValue(slider: slider4)
        }
    }
    
    var currentGameScore: Float = 0.0 {
        didSet {
            scoreLabel.text = ("\(currentGameScore.rounded())")
        }
    }
    
    // Timer
    var timerIsPaused: Bool = true
    var timer = Timer()
    var seconds: Int = 0 {
        didSet {
            if seconds < 10 && minutes < 10 {
                timerLabel.text = ("0\(minutes):0\(seconds)")
            } else if seconds < 10 && minutes >= 10 {
                timerLabel.text = ("\(minutes):0\(seconds)")
            } else {
                timerLabel.text = ("0\(minutes):\(seconds)")
            }
        }
    }
    var minutes: Int = 0 {
        didSet {
            if minutes < 10 {
                timerLabel.text = ("0\(minutes):0\(seconds)")
            } else {
                timerLabel.text = ("\(minutes):0\(seconds)")
            }
        }
    }
    
    var gameSession: GameSession? {
        // TODO: Add userDefault functions to PersistenceHelper
        didSet {
            print(gameSession?.userScore.userName ?? "ERROR")
        }
    }
    var defaults = UserDefaults.standard
    
    //MARK:- View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSliders()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let userName = defaults.string(forKey: "userName") {
            gameSession?.userScore.userName = userName
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        //NOTE: This will rotate the entire sliderStack 90 degrees, to a vertical Orientation
        // sliderStackView.transform = CGAffineTransform.init(rotationAngle: .pi/2)
        setupBtnBoundary()
    }
    
    //MARK:- Functions
    private func startTimer() {
        timerIsPaused.toggle()
        if timerIsPaused == false {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { tempTimer in
                if self.seconds == 59 {
                    self.seconds = 00
                    if self.minutes == 59 {
                        self.minutes = 00
                    } else {
                        self.minutes = self.minutes + 1
                    }
                } else {
                    self.seconds = self.seconds + 1
                    self.animateSliderImage(slider: self.slider1)
                    self.animateSliderImage(slider: self.slider2)
                    self.animateSliderImage(slider: self.slider3)
                    self.animateSliderImage(slider: self.slider4)
                }
            }
        } else {
            timer.invalidate()
        }
    }
    private func animateSliderImage(slider: UISlider) {
        let duration = 1.0
        let climbRate: Float = 3.0
        switch slider {
        case slider1:
            checkSliderValue(slider: slider1)
            UIView.animate(withDuration: duration, animations: {
                slider.setValue(self.slider1.value + climbRate, animated: true)
            })
        case slider2:
            checkSliderValue(slider: slider2)
            UIView.animate(withDuration: duration, animations: {
                slider.setValue(self.slider2.value + climbRate, animated: true)
            })
        case slider3:
            checkSliderValue(slider: slider3)
            UIView.animate(withDuration: duration, animations: {
                slider.setValue(self.slider3.value + climbRate, animated: true)
            })
        case slider4:
            checkSliderValue(slider: slider4)
            UIView.animate(withDuration: duration, animations: {
                slider.setValue(self.slider4.value + climbRate, animated: true)
            })
        default:
            return
        }
        self.view.layoutIfNeeded()
        let animator = UIViewPropertyAnimator(duration: 1, curve: .easeIn) {
        }
        animator.startAnimation()
    }
    private func checkSliderValue(slider: UISlider) {
        if slider.value == slider.maximumValue {
            slider.isEnabled = false
        } else {
            slider.isEnabled = true
        }
    }
    func setupBtnBoundary() {
        breathingButtonBoundary.layer.cornerRadius = breathingButtonBoundary.frame.width / 2
        breathingButton.layer.cornerRadius = breathingButton.frame.width / 2
    }
    func startButtonAnimation() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .curveEaseIn) {
            self.startTimerButton.transform = CGAffineTransform(rotationAngle: .pi/2)
            self.startTimerButton.transform = CGAffineTransform(rotationAngle: .pi)
            self.startTimerButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.startTimerButton.alpha = 0
        } completion: { _ in
            print("start button poof")
        }
    }
    @objc func animate() {
        UIView.animateKeyframes(withDuration: 10,
                                delay: 0.5,
                                options: [.allowUserInteraction, .beginFromCurrentState]) {
            self.breathingButton.transform = CGAffineTransform(scaleX: 5, y: 5)
            UIView.addKeyframe(withRelativeStartTime: 0.5/4, relativeDuration: 1/4) {
                self.breathingButton.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            }
            UIView.addKeyframe(withRelativeStartTime: 2/4, relativeDuration: 1/4) {
                self.breathingButton.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            }
            UIView.addKeyframe(withRelativeStartTime: 3.5/4, relativeDuration: 1/4) {
                self.breathingButton.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
            }
        } completion: { _ in
            print("stop")
            self.breathingButton.isEnabled = false
        }
    }
    func revertAnimate() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear, .beginFromCurrentState]) {
            //            self.breathingButton.isEnabled = true
            self.breathingButton.layer.removeAllAnimations()
            self.breathingButton.transform = .identity
            self.breathingButton.backgroundColor = #colorLiteral(red: 0.2052684426, green: 0.7807833552, blue: 0.3487253785, alpha: 1)
        } completion: { _ in
            self.breathingButton.isEnabled = true
            print("reverted")
            self.animate()
        }
    }
    
    //MARK:- @IBActions
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        var min: Float = 0.0
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                switch slider {
                case slider1:
                    if slider.value > slider1MaxValue {
                        slider1MaxValue = slider.value
                    }
                case slider2:
                    if slider.value > slider1MaxValue {
                        slider2MaxValue = slider.value
                    }
                case slider3:
                    if slider.value > slider1MaxValue {
                        slider3MaxValue = slider.value
                    }
                case slider4:
                    if slider.value > slider1MaxValue {
                        slider4MaxValue = slider.value
                    }
                default:
                    return
                }
            case .ended:
                min = slider.value
                switch slider {
                case slider1:
                    currentGameScore = (currentGameScore + (slider1MaxValue - min))
                case slider2:
                    currentGameScore = (currentGameScore + (slider2MaxValue - min))
                case slider3:
                    currentGameScore = (currentGameScore + (slider3MaxValue - min))
                case slider4:
                    currentGameScore = (currentGameScore + (slider4MaxValue - min))
                default:
                    return
                }
            default:
                break
            }
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        currentGameScore = 0
        slider1MaxValue = 0
        slider2MaxValue = 0
        slider3MaxValue = 0
        slider4MaxValue = 0
        timerLabel.text = "00:00"
        timer.invalidate()
    }
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let settingsViewController = storyboard.instantiateViewController(identifier: "Settings")
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        startTimer()
        if timerIsPaused {
            startTimerButton.setTitle("Start", for: .normal)
        } else {
            //            startButtonAnimation()
            animate()
            // TODO: Update animate func to stop the animation when the game is not being played?
            startTimerButton.setTitle("Stop", for: .normal)
        }
    }
    @IBAction func breathingButtonPressed(_ sender: UIButton) {
        revertAnimate()
    }
    
}


//MARK:- Slider Setup Funcs
extension GameViewController {
    
    func setupSliders() {
        slider1.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        slider2.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        slider3.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        slider4.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
    }
}
