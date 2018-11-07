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
}
