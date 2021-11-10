//
//  UIViewController + Alerts.swift
//  TextCharsCounter
//
//  Created by Vladyslav Pavelko on 10.11.2021.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithSucccessOption(title: String?, message: String?, successHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            successHandler?()
        }))
        
        self.present(alertController, animated: true)
    }
    
    func showAlertWithCancelOption(title: String?, message: String?, successHandler: (() -> Void)?, cancelHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            successHandler?()
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (_) in
            cancelHandler?()
        }))
        self.present(alertController, animated: true)
    }
    
    func showError(error: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        guard let error = error else {
            return
        }
        
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error message title"), message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithTextField(title: String?, message: String?, placeholders: [String], successHandler: (([String]) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for text in placeholders {
            alertController.addTextField { (textField) in
                textField.placeholder = text
            }
        }
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            var result = [String]()
            if let textFields = alertController.textFields {
                for tf in textFields {
                    result.append(tf.text ?? "")
                }
            }
            
            successHandler?(result)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
