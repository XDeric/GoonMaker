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
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var slider3: UISlider!
    @IBOutlet weak var slider4: UISlider!
    @IBOutlet weak var sliderStackView: UIStackView!
    @IBOutlet weak var startTimerButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var leaderBoardButton: UIButton!
    
    @IBOutlet weak var breathingButtonOuterBoundary: UIView!
    @IBOutlet weak var breathingButtonInnerBoundary: UIView!
    @IBOutlet weak var breathingButton: UIButton!
    
    // Constraints
    @IBOutlet weak var timerLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scoreLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var resetLabelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var settingsButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leaderBoardTrailingConstraint: NSLayoutConstraint!

    //MARK:- Variable and Constants
    var timerLabelBound: CGFloat = -16
    var scoreLabelLowerBound: CGFloat = -20
    var leadingEdgeUpperBound: CGFloat = 20
    var trailingEdgeUpperBound: CGFloat = -20
    var resetLabelBound: CGFloat = 20
    var settingsButtonLowerBound: CGFloat = 20
    var leaderboardButtonLowerBound: CGFloat = 20
    
    var slider1MaxValue: Float = 0.0 {
        didSet {
            checkSliderValue(slider: slider1)
        }
    }
    var slider2MaxValue: Float = 0.0 {
        didSet {
            checkSliderValue(slider: slider2)
        }
    }
    var slider3MaxValue: Float = 0.0 {
        didSet {
            checkSliderValue(slider: slider3)
        }
    }
    var slider4MaxValue: Float = 0.0 {
        didSet {
            checkSliderValue(slider: slider4)
        }
    }
    var buttonMaxValue: Float = 0.0
    var currentGameScore: Float = 0.0 {
        didSet {
            scoreLabel.text = ("Score: \(currentGameScore.rounded())")
        }
    }
    var decrementedLifeForBreathingButton = false
    
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
    
    var gameSession = GameSession(isPlaying: false, lives: 3, userScore: UserScore(userName: "AAA", score: 0))
    var defaults = UserDefaults.standard
    
    var sliderStatus: Set<String> = ["slider1","slider2","slider3","slider4","breathBtn"]//for gameover condition
    var animator: UIViewPropertyAnimator!
    
    //MARK:- View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSliders()
        animateStartGameConstraints()
   //     animateBreathingButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadUserInfo()
    }
    override func viewDidAppear(_ animated: Bool) {
        //NOTE: This will rotate the entire sliderStack 90 degrees, to a vertical Orientation
        //        sliderStackView.transform = CGAffineTransform.init(rotationAngle: -.pi/2)
        setupBtnBoundary()
        loadUserInfo()
//        setupConstraintOrigins()
    }
    
    //MARK:- Functions
    func setupConstraintOrigins() {
        timerLabelBound = timerLabelTopConstraint.constant
        scoreLabelLowerBound = scoreLabelLeadingConstraint.constant
        resetLabelBound = resetLabelTrailingConstraint.constant
        settingsButtonLowerBound = settingsButtonLeadingConstraint.constant
        settingsButtonLowerBound = leaderBoardTrailingConstraint.constant
    }
    private func loadUserInfo() {
        if let userName = defaults.string(forKey: "userName") {
            gameSession.userScore.userName = userName
        }
    }
    private func toggleTimer() {
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
        let duration = 2.0
        let climbRate: Float = 10.0
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
        if buttonMaxValue < 100 {
            buttonMaxValue += 1
        }
        animator.startAnimation()
    }
    private func checkSliderValue(slider: UISlider) {
        if slider.value == slider.maximumValue {
            slider.isEnabled = false
            
            // Decrement user lives
            gameSession.lives -= 1
            checkForGameOver()
            
//            checkGameCondition()
        } else {
            slider.isEnabled = true
        }
    }
    func animateSliderBackgroundColors(_ slider: UISlider) {
        //        UIView.animateKeyframes(withDuration: 1,
        //                                delay: 0.0,
        //                                options: [.allowUserInteraction, .beginFromCurrentState]) {
        //            UIView.addKeyframe(withRelativeStartTime: 0.5/4, relativeDuration: 1/4) {
        //                slider.minimumTrackTintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        //            }
        //            UIView.addKeyframe(withRelativeStartTime: 2/4, relativeDuration: 1/4) {
        //                slider.minimumTrackTintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        //            }
        //            UIView.addKeyframe(withRelativeStartTime: 3.5/4, relativeDuration: 1/4) {
        //                slider.minimumTrackTintColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
        //            }
        //        } completion: { _ in
        //
        //        }
    }
    func setupBtnBoundary() {
        breathingButtonOuterBoundary.layer.cornerRadius = breathingButtonOuterBoundary.frame.width / 2
        breathingButton.layer.cornerRadius = breathingButton.frame.width / 2
        breathingButtonInnerBoundary.layer.cornerRadius = breathingButtonInnerBoundary.frame.width / 2
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
            //            print("start button poof")
        }
    }

  /* from GameBoardUI
    @objc func animateBreathingButton() {
        if gameSession.isPlaying {
  */

    ///setsup the animation for uiviewanimeproperty
    func animateBreathingButton(){
        animator = UIViewPropertyAnimator(duration: 10, curve: .easeIn, animations: {
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

              /* from GameBoardUI
            } completion: { _ in
                
                // Decrement player lives
                // TODO: This seems to be getting called too many times, resulting in game over too soon
                
                if self.decrementedLifeForBreathingButton == false {
                    self.gameSession.lives -= 1
                    self.checkForGameOver()
                    self.decrementedLifeForBreathingButton = true
                }
                //            self.checkGameCondition()
                self.breathingButton.isEnabled = false
               */
            }
        })
        animator.addCompletion { position in
            if position == .end {
                self.checkGameCondition()
                self.breathingButton.isEnabled = false
            }
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
        } else {
            // TODO: This is where we can pause the breathing button
            
            print("I want to pause the breathing button")
        }
    }
    func revertAnimate() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear, .beginFromCurrentState]) {
            self.breathingButton.layer.removeAllAnimations()
            self.breathingButton.transform = .identity
            self.breathingButton.backgroundColor = #colorLiteral(red: 0.2052684426, green: 0.7807833552, blue: 0.3487253785, alpha: 1)
        } completion: { _ in
            self.breathingButton.isEnabled = true
            self.buttonMaxValue = 0.0

            // self.animateBreathingButton()
            //print("reverted")
//            self.animate()
            self.animator.addAnimations {//once it's done playing one animation animator is empty so have to add a animation in
                self.animate()
            }
            self.animator.startAnimation() // then start it again and repeat
        }
    }
    func checkForGameOver() {
        if gameSession.isPlaying {
            if gameSession.lives <= 0 {
                print("game over")
                uploadScoreToFirebase(score: gameSession.userScore)
                gameSession.isPlaying = false
                startTimerButton.setTitle("Want to play again?", for: .normal)
                timer.invalidate()
                // TODO: Navigate to leaderboard here
            } else {
                print("still playing, lives left: \(gameSession.lives)")
            }
        }
    }
    func uploadScoreToFirebase(score: UserScore) {
        gameSession.userScore.score = Int(currentGameScore)
        FirestoreService.manager.createUserInfo(usrInfo: UserInfo(name: gameSession.userScore.userName, score: gameSession.userScore.score)) { (result) in
            switch result {
            case .success:
                print("pushed to FireBase")
            case let .failure(error):
                print("failed: \(error)")
            }
        }
    }
    func animateStartGameConstraints() {
        if timerIsPaused {
            // Paused
            /// Hide timer
            /// Hide score
            /// Show settings button
            /// Show leaderboard button
            /// Show Reset button
            
            // HIDE
            if timerLabel.alpha > 0 {
//            while timerLabelTopConstraint.constant > timerLabelBound {
//                timerLabelTopConstraint.constant -= 1
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.transitionCrossDissolve], animations: {
                    self.timerLabel.alpha = 0.0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
            while scoreLabelLeadingConstraint.constant > scoreLabelLowerBound {
                scoreLabelLeadingConstraint.constant -= 1
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.transitionCrossDissolve], animations: {
                    self.scoreLabel.alpha = 0.0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
            
            // SHOW
            while settingsButtonLeadingConstraint.constant < settingsButtonLowerBound {
                settingsButtonLeadingConstraint.constant += 1
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.transitionCrossDissolve], animations: {
                    self.settingsButton.alpha = 1.0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
            while leaderBoardTrailingConstraint.constant < 20 {
                leaderBoardTrailingConstraint.constant += 1
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.transitionCrossDissolve], animations: {
                    self.leaderBoardButton.alpha = 1.0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
//            while timerLabelTopConstraint.constant < 0 {
//                timerLabelTopConstraint.constant += 1
//                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.transitionCrossDissolve], animations: {
//                    self.timerLabel.alpha = 1.0
//                    self.view.layoutIfNeeded()
//                }, completion: nil)
//            }
        } else {
            // Playing
            /// Show timer
            /// Show Score
            /// Hide settings Button
            /// Hide leaderboard button
            /// Hide Reset button
            
            
            //SHOW
            if timerLabel.alpha < 1.0 {
//            while timerLabelTopConstraint.constant < 0 {
//                timerLabelTopConstraint.constant += 1
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.transitionCrossDissolve], animations: {
                    self.timerLabel.alpha = 1.0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
            while scoreLabelLeadingConstraint.constant < leadingEdgeUpperBound {
                scoreLabelLeadingConstraint.constant += 1
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.transitionCrossDissolve], animations: {
                    self.scoreLabel.alpha = 1.0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
            
            
            // HIDE
            while settingsButtonLeadingConstraint.constant > scoreLabelLowerBound {
                settingsButtonLeadingConstraint.constant -= 1
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.transitionCrossDissolve], animations: {
                    self.settingsButton.alpha = 0.0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
            while leaderBoardTrailingConstraint.constant > 0 {
                leaderBoardTrailingConstraint.constant -= 1
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.transitionCrossDissolve], animations: {
                    self.leaderBoardButton.alpha = 0.0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
//            while scoreLabelLeadingConstraint.constant > scoreLabelLowerBound {
//                scoreLabelLeadingConstraint.constant -= 1
//                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.transitionCrossDissolve], animations: {
//                    self.scoreLabel.alpha = 0.0
//                    self.view.layoutIfNeeded()
//                }, completion: nil)
//            }
            
        }
    }
 /* DEPRECATED
    func checkGameCondition() {
        //since i have this check condition in a animation it get called continuously which made my ints continously subtracted so i'm using a set to just remove unique item
        while gameSession.isPlaying {
        if slider1.isEnabled == false {
            sliderStatus.remove("slider1")
        }
        if slider2.isEnabled == false {
            sliderStatus.remove("slider2")
        }
        if slider3.isEnabled == false {
            sliderStatus.remove("slider3")
        }
        if slider4.isEnabled == false {
            sliderStatus.remove("slider4")
        }
        if breathingButton.isEnabled == false {
            sliderStatus.remove("breathBtn")
        }
        if sliderStatus.count <= 2 {
            timer.invalidate()
            print("game Over")
        } else {
            print("still playing")
        }
            //segue everything to leaderboard
//            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                  let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
//            else {return}
//            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
//                window.rootViewController = LeaderboardViewController()
//            }, completion: nil)
            // Game over condition
            // TODO: Decide what to do here, whether we upload to the leaderboard, no questions asked? Present the leaderboard? Show alert giving the user an option to submit to leaderboard with name and score?
            
            // Should we assign the gamescore an ID (UUID) to be able to highlight or call that score at a later point? For example: When they navigate to the leaderboard, we can show them their rank instead of simply the top scores and make them scroll
        }
        //push to firebase
//            FirestoreService.manager.createUserInfo(usrInfo: UserInfo(name: gameSession.userScore.userName, score: gameSession.userScore.score)) { (result) in
//                switch result {
//                case .success:
//                    print("pushed to FireBase")
//                case let .failure(error):
//                    print("failer \(error)")
//                }
//            }

        /*if slider1.isEnabled == false || slider2.isEnabled == false || slider3.isEnabled == false || slider4.isEnabled == false && breathingButton.isEnabled == false {
         // This is essentially instead of doing 5 lives
         }*/

    }
    */
    
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
                    if slider.value > slider2MaxValue {
                        slider2MaxValue = slider.value
                    }
                case slider3:
                    if slider.value > slider3MaxValue {
                        slider3MaxValue = slider.value
                    }
                case slider4:
                    if slider.value > slider4MaxValue {
                        slider4MaxValue = slider.value
                    }
                default:
                    return
                }
            case .ended:
                min = slider.value
                switch slider {
                case slider1:
                    if slider.value > slider1MaxValue {
                        slider.setValue(slider1MaxValue, animated: false)
                    } else if slider.value < slider1MaxValue {
                        let sliderScore = (slider1MaxValue - min)
                        currentGameScore = currentGameScore + sliderScore
                        slider1MaxValue = min
                    }
                case slider2:
                    if slider.value > slider2MaxValue {
                        slider.setValue(slider2MaxValue, animated: false)
                    } else if slider.value < slider2MaxValue {
                        let sliderScore = (slider2MaxValue - min)
                        currentGameScore = currentGameScore + sliderScore
                        slider2MaxValue = min
                    }
                case slider3:
                    if slider.value > slider3MaxValue {
                        slider.setValue(slider3MaxValue, animated: false)
                    } else if slider.value < slider3MaxValue {
                        let sliderScore = (slider3MaxValue - min)
                        currentGameScore = currentGameScore + sliderScore
                        slider3MaxValue = min
                    }
                case slider4:
                    if slider.value > slider4MaxValue {
                        slider.setValue(slider4MaxValue, animated: false)
                    } else if slider.value < slider4MaxValue {
                        let sliderScore = (slider4MaxValue - min)
                        currentGameScore = currentGameScore + sliderScore
                        slider4MaxValue = min
                    }
                default:
                    return
                }
            default:
                break
            }
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        // Reinitialize game scores to begin a new game
        currentGameScore = 0
        slider1MaxValue = 0
        slider2MaxValue = 0
        slider3MaxValue = 0
        slider4MaxValue = 0
        buttonMaxValue = 0
        timerLabel.text = "00:00"
        startTimerButton.setTitle("Start", for: .normal)
        
        // Reset the breathingButton and sliders
        slider1.setValue(1, animated: true)
        slider2.setValue(1, animated: true)
        slider3.setValue(1, animated: true)
        slider4.setValue(1, animated: true)
        // Note: Reset button to original size here?
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear, .beginFromCurrentState]) {
              self.breathingButton.layer.removeAllAnimations()
              self.breathingButton.transform = .identity
              self.breathingButton.backgroundColor = #colorLiteral(red: 0.2052684426, green: 0.7807833552, blue: 0.3487253785, alpha: 1)
        }
        // Stop the timer
        timer.invalidate()
        animateStartGameConstraints()
    }
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let settingsViewController = storyboard.instantiateViewController(identifier: "Settings")
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        //        animateSliderBackgroundColors(slider1)
        //        animateSliderBackgroundColors(slider2)
        //        animateSliderBackgroundColors(slider3)
        //        animateSliderBackgroundColors(slider4)
        toggleTimer()
            if timerIsPaused {
                startTimerButton.setTitle("Continue", for: .normal)
                animateBreathingButton()
                animateStartGameConstraints()
            } else {
                //            startButtonAnimation()
                gameSession.isPlaying = true
                animateBreathingButton()
                // TODO: Update animate func to stop the animation when the game is not being played?
                startTimerButton.setTitle("Pause", for: .normal)
                animateStartGameConstraints()
            }

      /* from prod on a merge...
        startTimer()
        if timerIsPaused {
            startTimerButton.setTitle("Start", for: .normal)
            animator.pauseAnimation()
        } else {
            animator.startAnimation()
            // TODO: Update animate func to stop the animation when the game is not being played?
            startTimerButton.setTitle("Stop", for: .normal)
        }
      */

    }
    @IBAction func breathingButtonPressed(_ sender: UIButton) {
        currentGameScore = currentGameScore + buttonMaxValue
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
