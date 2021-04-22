//
//  Additional.swift
//  Accenture
//
//  Created by Matthew on 21/4/21.
//

import Foundation
import UIKit

struct Add {
    func getColor(color: String) -> UIColor {
        if color == "red" {
            return UIColor.red
        } else if color == "blue" {
            return UIColor.blue
        } else {
            return UIColor.black
        }
    }
}
 
class Alert {
class func show(title: String, message: String, vc: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    vc.present(alert, animated: true)
    }
}
