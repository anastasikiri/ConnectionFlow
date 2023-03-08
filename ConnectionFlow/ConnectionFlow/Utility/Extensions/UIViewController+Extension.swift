//
//  UIViewController+Extension.swift
//  ConnectionFlow
//
//  Created by Anastasia Bilous on 2023-03-06.
//

import UIKit

extension UIViewController {
    
    func showBasicAlert(title: String, vc: UIViewController) {
        let alert = UIAlertController (title: title,
                                       message: nil,
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        vc.present(alert,animated: true)
    }
}
