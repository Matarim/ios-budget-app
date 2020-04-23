//
//  HomeViewController.swift
//  Budgety
//
//  Created by Matthew Rampey on 3/28/20.
//  Copyright © 2020 Matthew Rampey. All rights reserved.
//

import UIKit
import CoreData

let incomeNotificationKey = "incomeKey"
let expenseNotificationKey = "expenseKey"
let currentAmt = UserDefaults.standard

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
    
    deinit {
        self.reloadInputViews()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if amountAvailable.text == "" {
            amountAvailable.text = "0"
        }
        createObserver()
        getdata()
        performCalc()
        
    }
    
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
    
    func performCalc() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if incexpArr.count > 0 {
            separatingData()
            amountAvailable.text = formatter.string(from: NSNumber(value: incomeArr.reduce(0, +) - expenseArr.reduce(0, +)))
        } else {
            amountAvailable.text = String(previousAmount)
        }
    }
    
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
            let amtAvail = notification.object as! IncomeViewController
            self.newAmount = Double(amtAvail.amountDeclared)!
            self.previousAmount = (self.amountAvailable.text!).removeFormatAmount()
            self.amountAvailable.text! = formatter.string(from: NSNumber(value: self.previousAmount - self.newAmount))!

         }
        
    }
    
}

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
