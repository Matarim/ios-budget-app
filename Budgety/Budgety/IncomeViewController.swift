//
//  ViewController.swift
//  Budgety
//
//  Created by Matthew Rampey on 3/26/20.
//  Copyright © 2020 Matthew Rampey. All rights reserved.
//

import UIKit

class IncomeViewController: UIViewController {
    
    @IBOutlet weak var inputTextField: UITextField!
    
    private var datePicker: UIDatePicker?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var incomeNote: UITextField!
    @IBOutlet weak var incomeTitle: UITextField!
    @IBOutlet weak var incomeAmount: UITextField!
    @IBOutlet weak var labelField: UILabel!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var repeatSelection: UITextField!

    var amountDeclared: String {
        incomeAmount.text!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(IncomeViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(IncomeViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        inputTextField.inputView = datePicker
        self.switchMode(self)
    }
    
    @IBAction func createData_btn(_ sender: UIButton) {
        NotificationCenter.default.post(name: .incomeKey, object: self)
        dismiss(animated: true)
    }
    
    
    @IBAction func cancelData_btn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        inputTextField.text = dateFormatter.string(from: datePicker.date)
        //Undecided if this is wanted because it essentially auto closes the date picker potentially before the selection was finished....
        //view.endEditing(true)
    }
    
    @IBAction func switchMode(_ sender: Any) {
        let textFields: [UITextField] = [repeatSelection]
        if repeatSwitch.isOn == false{
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = UITextField.BorderStyle.none
            }

        }
        else if repeatSwitch.isOn == true {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = UITextField.BorderStyle.roundedRect
            }
            
        }
    }

}

