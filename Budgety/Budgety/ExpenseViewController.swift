//
//  ExpenseViewController.swift
//  Budgety
//
//  Created by Matthew Rampey on 3/26/20.
//  Copyright © 2020 Matthew Rampey. All rights reserved.
//

import UIKit
import CoreData

class ExpenseViewController: UIViewController {

    @IBOutlet weak var inputTextField: UITextField!
    
    private var datePicker: UIDatePicker?
    @IBOutlet weak var expenseTitle: UITextField!
    @IBOutlet weak var expenseAmount: UITextField!
    @IBOutlet weak var createData_btn: UIButton!
    @IBOutlet weak var cancelData_btn: UIButton!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var expenseNote: UITextField!
    @IBOutlet weak var repeatSelection: UITextField!
    
    var expTitle = ""
    var expAmount = ""
    var expNote = ""
    
    var amountDeclared: String {
        expenseAmount.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(ExpenseViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ExpenseViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        inputTextField.inputView = datePicker
        self.switchMode(self)
    }
    
    @IBAction func createData_btn(_ sender: Any) {
        NotificationCenter.default.post(name: .expenseKey, object: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let expDate = dateFormatter.date(from: inputTextField.text!)
        self.expTitle = expenseTitle.text!
        self.expAmount = expenseAmount.text!
        self.expNote = expenseNote.text!
        let expense = Expense(context: PersistenceService.context)
        expense.amount = Double(self.expAmount)!
        expense.title = self.expTitle
        expense.note = self.expNote
        expense.date = expDate
        expense.isIncome = false
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
