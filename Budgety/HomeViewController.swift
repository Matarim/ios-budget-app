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
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        previousAmount = Double(amountAvailable.text!)!
        getdata()
        if incexpArr.count != previousCount {
            performCalc()
        } else {
            amountAvailable.text = String(previousAmount)
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
        if incexpArr.count > 0 {
            separatingData()
            amountAvailable.text = String(incomeArr.reduce(0, +) - expenseArr.reduce(0, +))
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
            let amtAvail = notification.object as! IncomeViewController
            self.previousAmount = Double(self.amountAvailable.text!)!
            self.newAmount = Double(amtAvail.amountDeclared)!
            self.income = true
            self.getdata()
            self.amountAvailable.text! = String(self.previousAmount + self.newAmount)
            
        }
        
        NotificationCenter.default.addObserver(forName: .expenseKey, object: nil, queue: OperationQueue.main) {
             (notification) in
            let amtAvail = notification.object as! ExpenseViewController
            self.previousAmount = Double(self.amountAvailable.text!)!
            self.newAmount = Double(amtAvail.amountDeclared)!
            self.expense = true
            self.getdata()
            self.amountAvailable.text! = String(self.previousAmount - self.newAmount)

         }
        
    }
    
}


