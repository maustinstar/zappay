//
//  ZURoundedView.swift
//  zapui
//
//  Created by Michael Verges on 10/26/19.
//  Copyright © 2019 Michael Verges. All rights reserved.
//

import UIKit

@IBDesignable
class ZURoundedView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 15.0 {
        didSet { self.layer.mask = maskLayer }
    }
    
    @IBInspectable var topLeftCorner: Bool = true {
        didSet {
            self.layer.mask = maskLayer
        }
    }
    
    @IBInspectable var topRightCorner: Bool = true {
        didSet {
            self.layer.mask = maskLayer
        }
    }
    
    @IBInspectable var bottomLeftCorner: Bool = true {
        didSet {
            self.layer.mask = maskLayer
        }
    }
    
    @IBInspectable var bottomRightCorner: Bool = true {
        didSet {
            self.layer.mask = maskLayer
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.mask = maskLayer
    }

    private var maskLayer: CAShapeLayer {
        
        var corners: [UIRectCorner] = []
        if topLeftCorner { corners.append(.topLeft) }
        if topRightCorner { corners.append(.topRight) }
        if bottomLeftCorner { corners.append(.bottomLeft) }
        if bottomRightCorner { corners.append(.bottomRight) }
        
        let path = UIBezierPath(
            roundedRect:        bounds,
            byRoundingCorners:  UIRectCorner(corners),
            cornerRadii:        CGSize(width: cornerRadius, height: cornerRadius)
        )
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        return mask
    }

}
