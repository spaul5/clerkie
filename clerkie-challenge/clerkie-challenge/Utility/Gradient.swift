//
//  Gradient.swift
//  clerkie-challenge
//
//  Created by Shouvik Paul on 11/6/18.
//

import UIKit

@IBDesignable
final class GradientView: UIView {
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear
    var gradient: CAGradientLayer!
    
    override func draw(_ rect: CGRect) {
        gradient = CAGradientLayer()
        gradient.frame = rect
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.zPosition = -1
        layer.addSublayer(gradient)
    }
    
//    func addGradient(height: CGFloat) {
//        removeGradient()
//
//        gradient = CAGradientLayer()
//        let newFrame = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.maxX, height: height + 1)
//        gradient.frame = newFrame
//        gradient.colors = [startColor.cgColor, endColor.cgColor]
//        gradient.zPosition = -1
//        layer.addSublayer(gradient)
//    }
//
//    func removeGradient() {
//        if let g = gradient {
//            g.removeFromSuperlayer()
//        }
//    }
}
