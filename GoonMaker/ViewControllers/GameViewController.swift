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
    
    @IBOutlet weak var buttonBoundary: UIView!
    @IBOutlet weak var shrnkButtonOutlet: UIButton!
    
    @IBAction func shrinkButton(_ sender: Any) {
    }
    
    func setupBtnBoundary(){
        buttonBoundary.layer.cornerRadius = buttonBoundary.frame.width / 2
        shrnkButtonOutlet.layer.cornerRadius = shrnkButtonOutlet.frame.width / 2
    }
    
    
    
//    var mytimer =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    
    @objc func timerAction(){
//            let Range =  slider0.maximumValue - slider0.minimumValue;
//            let Increment = Range/100;
//            let newval = slider0.value + Increment;
//            if(Increment <= slider0.maximumValue)
//            {
//                slider0.setValue(newval, animated: true)
//                print("The value of the slider is now \(slider0.value)")
//                sliderValue = Int(slider0.value)
//            }
//            else if (Increment >= slider0.minimumValue)
//            {
//                slider0.setValue(newval, animated: true)
//            }
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

