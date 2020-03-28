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

class HomeViewController: UIViewController {
    @IBOutlet weak var amountAvailable: UILabel!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createObserver()

    }
    
    func createObserver() {
        
        NotificationCenter.default.addObserver(forName: .incomeKey, object: nil, queue: OperationQueue.main) {
            (notification) in
            let amtAvail = notification.object as! IncomeViewController
            self.amountAvailable.text = amtAvail.amountDeclared
        }
        
        NotificationCenter.default.addObserver(forName: .expenseKey, object: nil, queue: OperationQueue.main) {
             (notification) in
             let amtAvail = notification.object as! ExpenseViewController
             self.amountAvailable.text = amtAvail.amountDeclared
         }
        
    }
    
}


