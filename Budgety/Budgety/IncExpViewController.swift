//
//  IncExpViewController.swift
//  Budgety
//
//  Created by Matthew Rampey on 3/30/20.
//  Copyright © 2020 Matthew Rampey. All rights reserved.
//

import UIKit
import CoreData

class IncExpTableCellView: UITableViewCell {
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

}

class IncExpViewController: UIViewController, UITableViewDelegate {
    @IBOutlet var tableView : UITableView!
    @IBOutlet weak var monthLabel: UILabel!
    
    
    var selected:Bool = false
    
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
        tableView.tableFooterView = UIView()

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
    
   var selectedIndex: IndexPath = IndexPath(row: -1, section: 0)
    
}

extension IncExpViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndex {
            return 200
        }
        
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(expenseArr.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IncExpTableCellView
        
        
        let expense = expenseArr[indexPath.row]
        cell.backgroundColor = .red
        cell.titleLabel?.text = expense.title
        cell.amountLabel?.text = String(expense.amount)
        cell.noteLabel?.text = expense.note
        cell.noteLabel?.sizeToFit()
        cell.dateLabel?.text = dateFormatter.string(for: expense.date)!
        
        animate()
        return(cell)
    }
    
    func animate() {
          UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options:  .curveEaseIn, animations: { self.tableView.layoutIfNeeded()})
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath
        
          
        tableView.beginUpdates()
        tableView.reloadRows(at: [selectedIndex], with: .none)
        tableView.endUpdates()
    }
    
}
