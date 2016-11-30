//
//  ViewController.swift
//  NanoInteractive
//
//  Created by Nathan Fulkerson on 11/1/16.
//  Copyright © 2016 Nathan Fulkerson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    
    
    enum AdventureError : Error {
        case noName
    }
    
    @IBOutlet weak var nameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
            selector: #selector(ViewController.keyboardWillShow(notification:)),
            name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(notification:)),
            name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "adventureStartedSegue") {
            
            do {
                if let name = nameTextField.text {
                    if name == "" {
                        throw AdventureError.noName
                    }
                    
                    if let pageController = segue.destination as? PageViewController {
                        pageController.page = Adventure.story(name: name)
                    }
                }
            } catch AdventureError.noName {
                let alertController = UIAlertController(title: "Name Not Provided", message: "Enter a name to start the story.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                present(alertController, animated: true, completion: nil)
            } catch let error {
                fatalError("\(error)")
            }
            }
    }
    
    
    func keyboardWillShow(notification: Notification) {
        if let userInfoDict = notification.userInfo, let keyboardFrameValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.cgRectValue
//            functional but jumpy
//            textFieldBottomConstraint.constant = keyboardFrame.size.height + 10
            UIView.animate(withDuration: 0.8) {
                self.textFieldBottomConstraint.constant = keyboardFrame.size.height + 10
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        textFieldBottomConstraint.constant = 140
        view.layoutIfNeeded()
    }
    
// Prior to iOS 9 this would be necessary
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}

