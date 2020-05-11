//
//  HomeViewController.swift
//  Budgety
//
//  Created by Matthew Rampey on 3/28/20.
//  Copyright © 2020 Matthew Rampey. All rights reserved.
//

import UIKit
import CoreData

// Creates Global variables for the observer keys
let incomeNotificationKey = "incomeKey"
let expenseNotificationKey = "expenseKey"

class HomeViewController: UIViewController {
    @IBOutlet weak var amountAvailable: UILabel!
    var previousAmount:Double = 0;
    var previousCount:Int = 0;
    var newAmount:Double = 0;
    var income = false;
    var expense = false;
    var incexpArr = [Parent]()
    var incomeArr = [Double]()
    var expenseArr = [Double]()
    
    // Removes the observer to prevent memory leaks and prevent performance issues
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if amountAvailable.text == "" {
            amountAvailable.text = "0"
        }
        // Calls these functions when the view appears
        getdata()
        performCalc()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createObserver()
    }
    
    // Retrieves all the data from CoreData
    func getdata(parentTypeIndex: String? = nil) {
        let fetchRequest: NSFetchRequest<Parent> = Parent.fetchRequest()
        do{
            incomeArr.removeAll()
            expenseArr.removeAll()
            let incexpArr = try PersistenceService.context.fetch(fetchRequest)
            self.incexpArr = incexpArr
        }
        catch {
            print("fetching failed")
        }
    }
    
    // performs the calculation based on income and expense
    func performCalc() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if incexpArr.count > 0 && incexpArr.count != previousCount {
            separatingData()
            amountAvailable.text = formatter.string(from: NSNumber(value: incomeArr.reduce(0, +) - expenseArr.reduce(0, +)))
        } else {
            previousAmount = (amountAvailable.text!).removeFormatAmount()
            amountAvailable.text! = formatter.string(from: NSNumber(value: previousAmount))!
        }
    }
    
    // Loops through array and splits income and expense into their own arrays
    func separatingData() {
        let sum = 0
        previousCount = incexpArr.count
        for item in incexpArr {
            if item.isIncome == true {
                let inc = incexpArr.remove(at: sum)
                incomeArr.append(inc.amount)
            } else {
                let exp = incexpArr.remove(at: sum)
                expenseArr.append(exp.amount)
            }
        }
    }
    
    // Creates observer to recognize when the income or expense modal is open and update the current amount
    func createObserver() {
        
        NotificationCenter.default.addObserver(forName: .incomeKey, object: nil, queue: OperationQueue.main) {
            (notification) in
            self.income = true
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            let amtAvail = notification.object as! IncomeViewController
            self.newAmount = Double(amtAvail.amountDeclared)!
            self.previousAmount = (self.amountAvailable.text!).removeFormatAmount()
            self.amountAvailable.text! = formatter.string(from: NSNumber(value: self.previousAmount + self.newAmount))!
        }
        
        NotificationCenter.default.addObserver(forName: .expenseKey, object: nil, queue: OperationQueue.main) {
             (notification) in
            self.expense = true
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            let amtAvail = notification.object as! ExpenseViewController
            self.newAmount = Double(amtAvail.amountDeclared)!
            self.previousAmount = (self.amountAvailable.text!).removeFormatAmount()
            self.amountAvailable.text! = formatter.string(from: NSNumber(value: self.previousAmount - self.newAmount))!

         }
        
    }
    
}

// creates an extension for stripping the currency formatting for adding the values
extension String {
    func removeFormatAmount() -> Double {
        let formatter = NumberFormatter()

        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.decimalSeparator = ","

        return formatter.number(from: self) as! Double? ?? 0
     }
}
