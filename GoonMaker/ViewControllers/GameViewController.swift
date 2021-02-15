//
//  ViewController.swift
//  GoonMaker
//
//  Created by EricM on 2/12/21.
//

import UIKit
import DSSlider

class GameViewController: UIViewController {
    
    @IBOutlet weak var sliderContainer0: UIView!
    @IBOutlet weak var sliderContainer1: UIView!
    @IBOutlet weak var sliderContainer2: UIView!
    @IBOutlet weak var sliderContainer3: UIView!
    
    var slider0 = DSSlider()
    var slider1 = DSSlider()
    var slider2 = DSSlider()
    var slider3 = DSSlider()
    
    var gameTimer: Timer?
    
    @IBOutlet weak var buttonBoundary: UIView!
    @IBOutlet weak var shrnkButtonOutlet: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    
    @IBAction func shrinkButton(_ sender: Any) {
        revertAnimate()
    }
    
    @IBAction func strtButton(_ sender: UIButton) {
        startBtn.isEnabled = false
        startButtonAnimation()
        animate()
    }
    func setupBtnBoundary(){
        buttonBoundary.layer.cornerRadius = buttonBoundary.frame.width / 2
        shrnkButtonOutlet.layer.cornerRadius = shrnkButtonOutlet.frame.width / 2
        
    }
    
    func startButtonAnimation(){
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .curveEaseIn) {
            self.startBtn.transform = CGAffineTransform(rotationAngle: .pi/2)
            self.startBtn.transform = CGAffineTransform(rotationAngle: .pi)
            self.startBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.startBtn.alpha = 0
        } completion: { _ in
            print("start button poof")
        }

    }
    
    @objc func animate(){
        UIView.animateKeyframes(withDuration: 10,
                                delay: 0.5,
                                options: [.allowUserInteraction, .beginFromCurrentState]) {
            self.shrnkButtonOutlet.transform = CGAffineTransform(scaleX: 5, y: 5)
            UIView.addKeyframe(withRelativeStartTime: 0.5/4, relativeDuration: 1/4) {
                self.shrnkButtonOutlet.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            }
            UIView.addKeyframe(withRelativeStartTime: 2/4, relativeDuration: 1/4) {
                self.shrnkButtonOutlet.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            }
            UIView.addKeyframe(withRelativeStartTime: 3.5/4, relativeDuration: 1/4) {
                self.shrnkButtonOutlet.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
            }
        } completion: { _ in
            print("stop")
            self.shrnkButtonOutlet.isEnabled = false
        }
        
    }
    func revertAnimate(){
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear, .beginFromCurrentState]) {
            self.shrnkButtonOutlet.isEnabled = true
            self.shrnkButtonOutlet.layer.removeAllAnimations()
            self.shrnkButtonOutlet.transform = .identity
            self.shrnkButtonOutlet.backgroundColor = #colorLiteral(red: 0.2052684426, green: 0.7807833552, blue: 0.3487253785, alpha: 1)
        } completion: { _ in
            print("reverted")
            self.animate()
        }
        
    }
    
    //MARK: Lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSliders(slider: slider0, UIViewContainer: sliderContainer0)
        setupSliders(slider: slider1, UIViewContainer: sliderContainer1)
        setupSliders(slider: slider2, UIViewContainer: sliderContainer2)
        setupSliders(slider: slider3, UIViewContainer: sliderContainer3)
        viewSetup()
        setupBtnBoundary()
//        gameTimer =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
        //        sliderHStackView.transform = CGAffineTransform(rotationAngle: .pi / 2)
        
    }
    
    
}

extension GameViewController : DSSliderDelegate {
    func sliderDidFinishSliding(_ slider: DSSlider, at position: DSSliderPosition) {
        print("slide")
    }
}

extension GameViewController {
    
    func viewSetup(){
        sliderContainer0.layer.cornerRadius = sliderContainer0.frame.height / 2
        sliderContainer1.layer.cornerRadius = sliderContainer1.frame.height / 2
        sliderContainer2.layer.cornerRadius = sliderContainer2.frame.height / 2
        sliderContainer3.layer.cornerRadius = sliderContainer3.frame.height / 2
    }
    
    func setupSliders(slider: DSSlider, UIViewContainer: UIView) {
        let slider = DSSlider(frame: UIViewContainer.frame, delegate: self)
        slider.isDoubleSideEnabled = true
        slider.isImageViewRotating = true
        slider.isTextChangeAnimating = true
        slider.isDebugPrintEnabled = false
        slider.isShowSliderText = true
        slider.isEnabled = true
        
        //        slider.transform = CGAffineTransform(rotationAngle: .pi/2)
        
        slider.sliderAnimationVelocity = 0.2
        slider.sliderViewTopDistance = 0.0
        slider.sliderImageViewTopDistance = 5
        slider.sliderImageViewStartingDistance = 5
        slider.sliderTextLabelLeadingDistance = 0
        slider.sliderCornerRadius = UIViewContainer.frame.height / 2
        
        slider.sliderBackgroundColor = UIColor.white
        slider.sliderBackgroundViewTextColor = DSSlider.dsSliderRedColor()
        slider.sliderDraggedViewTextColor = DSSlider.dsSliderRedColor()
        slider.sliderDraggedViewBackgroundColor = UIColor.gray
        slider.sliderImageViewBackgroundColor = DSSlider.dsSliderRedColor()
        slider.sliderTextFont = UIFont.systemFont(ofSize: 15.0)
        slider.sliderImageView.image = UIImage(systemName: "arrow-icon")
        slider.sliderBackgroundViewTextLabel.text = "SLIDE TO TURN ON!"
        slider.sliderDraggedViewTextLabel.text = "SLIDE TO TURN OFF!"
        view.addSubview(slider)
    }
    
}

