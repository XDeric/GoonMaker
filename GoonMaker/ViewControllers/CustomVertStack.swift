//
//  CustomVertStack.swift
//  GoonMaker
//
//  Created by Gregory Keeley on 2/16/21.
//

import UIKit

@IBDesignable class CustomVertStack: UIStackView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.transform = CGAffineTransform.init(rotationAngle: -.pi/2)
    }
}
