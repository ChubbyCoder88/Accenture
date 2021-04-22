//
//  Extensions.swift
//  Accenture
//
//  Created by Matthew on 20/4/21.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
extension UIColor {
    static let myGreen = UIColor(r: 0, g: 130, b: 40)
}
