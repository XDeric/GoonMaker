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
    @IBOutlet weak var sliderContainerView: UIView!
    
    //MARK:- Variables and Constants
    var slider = DSSlider()

     //MARK:- View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        setupSlider()
    }

    
     //MARK:- Functions
    func setupSlider() {
        
        slider = DSSlider(frame: sliderContainerView.frame, delegate: self)
        
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
        slider.sliderCornerRadius = sliderContainerView.frame.height / 2

        slider.sliderBackgroundColor = UIColor.white
        slider.sliderBackgroundViewTextColor = DSSlider.dsSliderRedColor()
        slider.sliderDraggedViewTextColor = DSSlider.dsSliderRedColor()
        slider.sliderDraggedViewBackgroundColor = UIColor.white
        slider.sliderImageViewBackgroundColor = DSSlider.dsSliderRedColor()

        slider.sliderTextFont = UIFont.systemFont(ofSize: 15.0)

        slider.sliderImageView.image = UIImage(named: "arrow-icon")
        slider.sliderBackgroundViewTextLabel.text = "SLIDE TO TURN ON!"
        slider.sliderDraggedViewTextLabel.text = "SLIDE TO TURN OFF!"

        // Constraints w/in container
        slider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
        
//            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            slider.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
//            slider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        
        ])
        
        view.addSubview(slider)
    }

}

 //MARK:- Extensions
extension GameViewController: DSSliderDelegate {
    func sliderDidFinishSliding(_ slider: DSSlider, at position: DSSliderPosition) {
        return
    }
    
    
}
