//
//  HelperClass.swift
//  TutorApp
//

import Foundation
import UIKit

class HelperClass {
    func alertBox(controller: UIViewController,title: String, message: String, ok: String, cancel: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: ok, style: UIAlertAction.Style.default, handler: nil))
        if cancel != nil {
            alert.addAction(UIAlertAction(title: cancel, style: UIAlertAction.Style.default, handler: nil))
        }
        controller.present(alert, animated: true, completion: nil)
    }
}
