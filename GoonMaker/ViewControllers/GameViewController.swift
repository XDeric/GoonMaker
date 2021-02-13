//
//  ViewController.swift
//  GoonMaker
//
//  Created by EricM on 2/12/21.
//

import UIKit
import DSSlider

class GameViewController: UIViewController {
     //MARK:- IBOutlets
    @IBOutlet weak var sliderContainer1: UIView!
    @IBOutlet weak var sliderContainer2: UIView!
    @IBOutlet weak var sliderContainer3: UIView!
    @IBOutlet weak var sliderContainer4: UIView!
    
    @IBOutlet weak var startTimerButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
  //MARK:- Variable and Constants
    //Score
    var slider1ScoreValue = 0
    var slider2ScoreValue = 0
    var slider3ScoreValue = 0
    var slider4ScoreValue = 0
    var currentScore = 0 {
        didSet {
            scoreLabel.text = ("\(currentScore)")
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
    
    var gameSession: GameSession?
    
     //MARK:- View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSlider(slider: sliderContainer1)
        setupSlider(slider: sliderContainer2)
        setupSlider(slider: sliderContainer3)
        setupSlider(slider: sliderContainer4)
    }
    private func reduceScore() {
        let scores = [slider1ScoreValue, slider2ScoreValue, slider3ScoreValue, slider4ScoreValue]
        let totalScore = scores.reduce(0, { x, y in
            x + y
        })
        currentScore = totalScore
    }
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
                    self.slider1ScoreValue += 1
                    self.slider2ScoreValue += 1
                    self.slider3ScoreValue += 1
                    self.slider4ScoreValue += 1
                    self.reduceScore()
                }
            }
        } else {
            timer.invalidate()
        }
    }
    
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        startTimer()
        if timerIsPaused {
            startTimerButton.setTitle("Start", for: .normal)
        } else {
            startTimerButton.setTitle("Stop", for: .normal)
        }
    }
    
}
extension GameViewController : DSSliderDelegate {
    func sliderDidFinishSliding(_ slider: DSSlider, at position: DSSliderPosition) {
        
    }
}


//MARK:- Slider Setup Funcs
extension GameViewController {
    
    func setupSlider(slider: UIView) {
        let slider = DSSlider(frame: slider.frame, delegate: self)
        slider.isDoubleSideEnabled = true
        slider.isImageViewRotating = true
        slider.isTextChangeAnimating = true
        slider.isDebugPrintEnabled = false
        slider.isShowSliderText = true
        slider.isEnabled = true
        slider.sliderAnimationVelocity = 0.2
        slider.sliderViewTopDistance = 0.0
        slider.sliderImageViewTopDistance = 5
        slider.sliderImageViewStartingDistance = 5
        slider.sliderTextLabelLeadingDistance = 0
        slider.sliderCornerRadius = slider.frame.height / 2
        slider.sliderBackgroundColor = UIColor.systemGray4
        slider.sliderBackgroundViewTextColor = DSSlider.dsSliderRedColor()
        slider.sliderDraggedViewTextColor = DSSlider.dsSliderRedColor()
        slider.sliderDraggedViewBackgroundColor = UIColor.gray
        slider.sliderImageViewBackgroundColor = DSSlider.dsSliderRedColor()
        slider.sliderTextFont = UIFont.systemFont(ofSize: 15.0)
        //  slider.sliderImageView.image = UIImage(systemName: "arrow-icon")
        slider.sliderBackgroundViewTextLabel.text = "SLIDE TO TURN ON!"
        slider.sliderDraggedViewTextLabel.text = "SLIDE TO TURN OFF!"
        
        slider.clipsToBounds = true
        
        slider.sizeToFit()
        
        view.addSubview(slider)
    }
}
