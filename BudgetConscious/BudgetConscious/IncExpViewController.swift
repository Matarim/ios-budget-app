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
    @IBOutlet weak var editBtn: UIButton!
    
}

class IncExpViewController: UIViewController, UITableViewDelegate {
    @IBOutlet var tableView : UITableView!
    @IBOutlet weak var monthLabel: UILabel!
    
    var selected:Bool = false
    
    var incexpArr = [Parent]()
    
    private var persistentContainer = NSPersistentContainer(name: "Parent")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.reloadData()
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        monthLabel.text = nameOfMonth
        tableView.tableFooterView = UIView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
        getdata()
        
        tableView.reloadData()
    }
    
    // Retrieves data from CoreData
    func getdata(parentTypeIndex: String? = nil) {
        let fetchRequest: NSFetchRequest<Parent> = Parent.fetchRequest()
        let sortDesc = NSSortDescriptor(keyPath: \Parent.date, ascending: true)
        fetchRequest.sortDescriptors = [sortDesc]
        let calendar = Calendar.current
        let currentDate = Date()
        let beginCurMonth = calendar.dateInterval(of: .month, for: currentDate)?.start
        let endCurMonth = calendar.dateInterval(of: .month, for: currentDate)?.end
        fetchRequest.predicate = NSPredicate(format: "date >= %@ && date < %@", beginCurMonth! as CVarArg, endCurMonth! as CVarArg)
        
        do {
            let incexpArr = try PersistenceService.context.fetch(fetchRequest)
            self.incexpArr = incexpArr
        } catch {
            print("fetching failed")
        }
    }
    
   var selectedIndex: IndexPath = IndexPath(row: -1, section: 0)
    
}

extension IncExpViewController: UITableViewDataSource{
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
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
        return(incexpArr.count)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dataItem = incexpArr[indexPath.row]
            PersistenceService.context.delete(dataItem)
            incexpArr.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
            PersistenceService.saveContext()
            saveContext()
            print(dataItem)
        }
        
    }
    
//  Handles displayiing cell and loading data into each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IncExpTableCellView
        
        let incexp = incexpArr[indexPath.row]
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
         
        cell.titleLabel?.text = incexp.title
        cell.amountLabel?.text = formatter.string(from: NSNumber(value: incexp.amount))
        cell.noteLabel?.text = incexp.note
        cell.noteLabel?.sizeToFit()
        cell.dateLabel?.text = dateFormatter.string(for: incexp.date)!
        
        animate()
        return cell
    
    }
//  Handles speed and animation for each cell expansion
    func animate() {
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options:  .curveEaseInOut, animations: { self.tableView.layoutIfNeeded()})
    }
//    Handles the color of the cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var red:UIColor
        var green:UIColor
        
        tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
        
        if cell.isSelected == true {
            red = UIColor(red: 2, green: 0, blue: 0, alpha: 1)
            green = UIColor(red: 0, green: 2, blue: 0, alpha: 1)
        } else {
            red = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
            green = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
        }
        
        let incexp = incexpArr[indexPath.row]
        if incexp.isIncome == true {
            cell.backgroundColor = green
        } else {
            cell.backgroundColor = red
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        selectedIndex = indexPath

        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
    }
    
}
