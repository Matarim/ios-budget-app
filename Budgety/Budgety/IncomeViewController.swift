//
//  ViewController.swift
//  Budgety
//
//  Created by Matthew Rampey on 3/26/20.
//  Copyright © 2020 Matthew Rampey. All rights reserved.
//

import UIKit
import CoreData

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
    
    var incTitle = ""
    var incAmount = ""
    var incNote = ""

    var amountDeclared: String {
        incomeAmount.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker = UIDatePicker()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(IncomeViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(IncomeViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        inputTextField.inputView = datePicker
        inputTextField.text = dateFormatter.string(from: Date())
        self.switchMode(self)
    }
    
    // Create button for modal and saves the data
    @IBAction func createData_btn(_ sender: UIButton) {
        NotificationCenter.default.post(name: .incomeKey, object: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let incDate = dateFormatter.date(from: inputTextField.text!)
        self.incTitle = incomeTitle.text!
        self.incAmount = incomeAmount.text!
        self.incNote = incomeNote.text!
        let income = Income(context: PersistenceService.context)
        income.amount = Double(self.incAmount)!
        income.title = self.incTitle
        income.note = self.incNote
        income.date = incDate
        income.isIncome = true
        PersistenceService.saveContext()
        dismiss(animated: true)
    }
    
    // Cancel button that dismisses Modal
    @IBAction func cancelData_btn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // Recognizes when modal is selected to close keyboard
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // Sets the date field to use a datepicker
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

        inputTextField.text = dateFormatter.string(from: datePicker.date)

    }
    
    // Adds a switch for the Modal for a future repeatable action
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

