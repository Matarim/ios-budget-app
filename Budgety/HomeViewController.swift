//
//  HomeViewController.swift
//  Budgety
//
//  Created by Matthew Rampey on 3/28/20.
//  Copyright © 2020 Matthew Rampey. All rights reserved.
//

import UIKit

let incomeNotificationKey = "incomeKey"
let expenseNotificationKey = "expenseKey"
let currentAmt = UserDefaults.standard

class HomeViewController: UIViewController {
    @IBOutlet weak var amountAvailable: UILabel!
    var previousAmount:Double = 0;
    var newAmount:Double = 0;
    var income = false;
    var expense = false;
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let x = currentAmt.object(forKey: "current_Amount") as? String {
            amountAvailable.text = x
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This makes sure that the label is not nil
        if amountAvailable.text == "" {
            amountAvailable.text = "0"
        }
        createObserver()
    }
    
    func performCalc() {
        previousAmount = Double(self.amountAvailable.text!)!
        if income == true {
            self.amountAvailable.text = String(previousAmount + newAmount)
            income = false
            
        } else if expense == true {
            self.amountAvailable.text = String(previousAmount - newAmount)
            expense = false
            
        } else {
            self.amountAvailable.text = String(previousAmount)
        }
        currentAmt.set(self.amountAvailable.text, forKey: "current_Amount")
    }
    
    func createObserver() {
        
        NotificationCenter.default.addObserver(forName: .incomeKey, object: nil, queue: OperationQueue.main) {
            (notification) in
            let amtAvail = notification.object as! IncomeViewController
            //let convrtAmt = amtAvail.amountDeclared
            //self.amountAvailable.text = amtAvail.amountDeclared
            self.newAmount = Double(amtAvail.amountDeclared)!
            self.income = true
            self.performCalc()
        }
        
        NotificationCenter.default.addObserver(forName: .expenseKey, object: nil, queue: OperationQueue.main) {
             (notification) in
            let amtAvail = notification.object as! ExpenseViewController
            //preferences.set(self.amountAvailable, forKey: "available_balance")
            self.newAmount = Double(amtAvail.amountDeclared)!
            self.expense = true
            self.performCalc()
         }
        
    }
    
}


