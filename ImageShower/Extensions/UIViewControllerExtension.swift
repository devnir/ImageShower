//
//  UIViewControllerExtension.swift
//  ImageShower
//
//  Created by Андрей Белогородский on 08.02.2023.
//

import UIKit


extension UIViewController {
    func showAlert(alertTitle : String, alertMessage : String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
