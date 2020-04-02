//
//  IncExpViewController.swift
//  Budgety
//
//  Created by Matthew Rampey on 3/30/20.
//  Copyright © 2020 Matthew Rampey. All rights reserved.
//

import UIKit
import CoreData

class IncExpViewController: UIViewController, UITableViewDelegate {
    @IBOutlet var tableView : UITableView!
    @IBOutlet weak var monthLabel: UILabel!
    var expenseArr = [Expense]()
    
    private var persistentContainer = NSPersistentContainer(name: "Expense")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        monthLabel.text = nameOfMonth
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getdata()
        tableView.reloadData()
    }
    
    func getdata() {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        do{
            let expenseArr = try PersistenceService.context.fetch(fetchRequest)
            self.expenseArr = expenseArr
        }
        catch {
            print("fetching failed")
        }
    }
    
}

extension IncExpViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(expenseArr.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = expenseArr[indexPath.row].title
        cell.detailTextLabel?.text = String(expenseArr[indexPath.row].amount)
        cell.detailTextLabel?.text = expenseArr[indexPath.row].note
        cell.detailTextLabel?.text = dateFormatter.string(for: expenseArr[indexPath.row].date as? Date)
        
        return(cell)
    }
}
