//
//  ViewController.swift
//  PopDatePickerApp
//
//  Created by Valerio Ferrucci on 07/10/14.
//  Copyright (c) 2014 Valerio Ferrucci. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var popDatePicker : PopDatePicker?
    
    @IBOutlet weak var viewController: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popDatePicker = PopDatePicker(forViewController : viewController)
        dobTextField.delegate = self
        
    }
    
    func resign() {
        
        dobTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
    }
    
func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    
    if (textField === dobTextField) {
        resign()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        let initDate = formatter.dateFromString(dobTextField.text)
        
        popDatePicker!.pick(self, initDate:initDate, dataChanged: { (newDate : NSDate, forTextField : UITextField) -> () in
            
            // here we don't use self (no retain cycle)
            forTextField.text = newDate.description
            
        })
        return false
    }
    else {
        return true
    }
}
    
    @IBAction func save(sender: AnyObject) {
        
        var msg : String
        if nameTextField.text != "" && dobTextField.text != "" {
            msg = nameTextField.text + " " + dobTextField.text
        } else {
            msg = "Name or Date empty!"
        }
        let alert:UIAlertController = UIAlertController(title: title, message: msg, preferredStyle:.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            
        }))
        self.presentViewController(alert, animated:true, completion:nil);
        
    }
}

