//
//  Utilities.swift
//  clerkie-challenge
//
//  Created by Shouvik Paul on 11/6/18.
//

import UIKit

class Utilities {
    static let shared = Utilities()
}

let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,8}"
let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)

let __phoneRegex = "^\\d{10}$"//"^\\d{3}-\\d{3}-\\d{4}$"
let __phonePredicate = NSPredicate(format: "SELF MATCHES %@", __phoneRegex)

extension String {
    func isValidEmail() -> Bool {
        return __emailPredicate.evaluate(with: self)
    }
    
    func isValidPhone() -> Bool {
        return __phonePredicate.evaluate(with: self)
    }
}

extension UIColor {
    @nonobjc class var clerkieRed: UIColor {
        return UIColor(red: 234.0 / 255.0, green: 63.0 / 255.0, blue: 81.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var clerkieLightGray: UIColor {
        return UIColor(red: 222.0 / 255.0, green: 222.0 / 255.0, blue: 222.0 / 255.0, alpha: 1.0)
    }
}

extension UIViewController {
    
    func presentFromRight(_ vc: UIViewController, completion: (()-> Void)? = nil) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        DispatchQueue.main.async {
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.present(vc, animated: false, completion: completion)
        }
    }
    
    func dismissFromLeft(completion: (()-> Void)? = nil) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        DispatchQueue.main.async {
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.dismiss(animated: false, completion: completion)
        }
    }
    
    func addDismissScreenEdgePanGesture() {
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
    }
    
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            print("Screen edge swiped!")
            dismissFromLeft()
        }
    }
}

class PaddingLabel: UILabel {
    
    var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect.inset(by: edgeInsets))
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: edgeInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + edgeInsets.left + edgeInsets.right,
                      height: size.height + edgeInsets.top + edgeInsets.bottom)
    }
}
