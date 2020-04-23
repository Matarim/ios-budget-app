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
//        incomeAmount.addTarget(self, action: #selector(IncomeViewController.textFieldDidChange(_:)),
//        for: .editingChanged)
        
        inputTextField.inputView = datePicker
        inputTextField.text = dateFormatter.string(from: Date())
        self.switchMode(self)
    }
    
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        if let amountString = incomeAmount.text?.currencyInputFormatting() {
//            incomeAmount.text = amountString
//        }
//    }
    
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
//        view.endEditing(true)
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

//extension String {
//
//    // formatting text for currency textField
//    func currencyInputFormatting() -> String {
//
//        var number: NSNumber!
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currencyAccounting
//        formatter.currencySymbol = "$"
//        formatter.maximumFractionDigits = 2
//        formatter.minimumFractionDigits = 2
//
//        var amountWithPrefix = self
//
//        // remove from String: "$", ".", ","
//        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
//        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
//
//        let double = (amountWithPrefix as NSString).doubleValue
//        number = NSNumber(value: (double / 100))
//
//        // if first number is 0 or all numbers were deleted
//        guard number != 0 as NSNumber else {
//            return ""
//        }
//
//        return formatter.string(from: number)!
//    }
//}
