//
//  IncExpViewController.swift
//  Budgety
//
//  Created by Matthew Rampey on 3/30/20.
//  Copyright © 2020 Matthew Rampey. All rights reserved.
//

import UIKit
import CoreData

// Individual cells to have specific labels
class IncExpTableCellView: UITableViewCell {
    @IBOutlet weak var noteField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var dateField: UITextField!
        
}

class IncExpViewController: UIViewController, UITableViewDelegate {
    
    // Array for each month
    var months = ["January", "February", "March", "April",
                 "May", "June", "July", "August", "September",
                "October", "November", "December"]
    
    var selectedMonth:String = ""
    
    @IBOutlet weak var monthAmtLabel: UILabel!
    @IBOutlet var tableView : UITableView!
    @IBOutlet weak var monthField: UITextField!
    
    var titleEDT = ""
    var amountEDT:Double = 0
    var noteEDT = ""
    
    var monthAmt:Double = 0
    
    // Removes the observers to keep from memory leaks and performance issues
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var selected:Bool = false
    
    var incexpArr = [Parent]()
    var incomeArr = [Double]()
    var expenseArr = [Double]()
    
    private var persistentContainer = NSPersistentContainer(name: "Parent")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.reloadData()
        tableView.tableFooterView = UIView()
        createMonthPicker()
        createToolBar()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        monthField.text = nameOfMonth
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
        // Calls these functions when the view appears
        getdata()
        getMonthAmt()
        tableView.reloadData()

    }
    
    // Sets the view based on month selected and utilizes the Picker
    func createMonthPicker() {
        let thePicker = UIPickerView()
        thePicker.delegate = self
        
        monthField.inputView = thePicker
        
    }
    
    // Adds a toolbar to the picker for added a Done button
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(IncExpViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        monthField.inputAccessoryView = toolBar
    }
    
    // Dismisses the drop-down when button is picked
    @objc func dismissKeyboard(){
        view.endEditing(true)
        tableView.reloadData()
    }
    
    // Does math for the current month
    func getMonthAmt() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        monthAmtLabel.text = formatter.string(from: NSNumber(value: incomeArr.reduce(0, +) - expenseArr.reduce(0, +)))
        incomeArr.removeAll()
        expenseArr.removeAll()
    }
    
    // Retrieves Data from CoreData
    func getdata(parentTypeIndex: String? = nil) {
        let fetchRequest: NSFetchRequest<Parent> = Parent.fetchRequest()
        let sortDesc = NSSortDescriptor(keyPath: \Parent.date, ascending: true)
        fetchRequest.sortDescriptors = [sortDesc]
        let calendar = Calendar.current
        let currentDate = Date()
        let beginCurMonth = calendar.dateInterval(of: .month, for: currentDate)?.start
        let endCurMonth = calendar.dateInterval(of: .month, for: currentDate)?.end
        fetchRequest.predicate = NSPredicate(format: "date >= %@ && date < %@", beginCurMonth! as CVarArg, endCurMonth! as CVarArg)
       
        // Catch block to protect bad data from being retrieved
        do{
            let incexpArr = try PersistenceService.context.fetch(fetchRequest)
            self.incexpArr = incexpArr
            
            for item in incexpArr {
                if item.isIncome == true {
                    incomeArr.append(item.amount)
                } else {
                    expenseArr.append(item.amount)
                }
            }
        }
        catch {
            print("fetching failed")
        }
    }
   // sets index to absolute zero so no rows are expanded
   var selectedIndex: IndexPath = IndexPath(row: -1, section: 0)
    
}

// extension for tableview
extension IncExpViewController: UITableViewDataSource{
    
    // Saves changes to CoreData
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
    
    // Adds delete button to each row when swipped
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
        
        // Places the switch inside of each cell
        let editSwitch = UISwitch(frame: CGRect(x: UIScreen.main.bounds.width-75, y: 150, width: 30, height: 30))
        editSwitch.tag = indexPath.row
        editSwitch.setOn(false, animated: true)
        editSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        editSwitch.onTintColor = UIColor.darkGray
     
        cell.titleField?.text = incexp.title
        cell.amountField?.text = formatter.string(from: NSNumber(value: incexp.amount))
        cell.noteField?.text = incexp.note
        cell.noteField.textAlignment = .left
        cell.noteField.contentVerticalAlignment = .top
        cell.noteField?.sizeToFit()
        cell.dateField?.text = dateFormatter.string(for: incexp.date)!
        cell.addSubview(editSwitch)
        
        animate()
        return cell
    
    }
    // Function for the switch inside of each cell
    @objc func switchChanged(_ sender: UISwitch!){
        
        let cell = tableView.cellForRow(at: IndexPath(indexes: self.selectedIndex)) as! IncExpTableCellView

        let textFields: [UITextField] = [cell.titleField, cell.amountField, cell.noteField, cell.dateField]
        
        let datepicker = UIDatePicker()
        datepicker.datePickerMode = .date
        cell.dateField.inputView = datepicker
        cell.amountField.keyboardType = UIKeyboardType.decimalPad
        cell.titleField.addDoneButtonOnKeyboard()
        cell.noteField.addDoneButtonOnKeyboard()
        cell.noteField.textAlignment = .left
        cell.noteField.contentVerticalAlignment = .top
        cell.amountField.addDoneButtonOnKeyboard()
        cell.dateField.addDoneButtonOnKeyboard()
        
        let dataItem = incexpArr[self.selectedIndex.row]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateFLD = dateFormatter.date(from: cell.dateField.text!)
        
        // Checks to see if the switch is selected
        if sender.isOn == false {
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = UITextField.BorderStyle.none
                self.titleEDT = cell.titleField.text!
                self.amountEDT = (cell.amountField.text!).removeFormatAmount()
                self.noteEDT = cell.noteField.text!
                dataItem.amount = Double(self.amountEDT)
                dataItem.title = self.titleEDT
                dataItem.note = self.noteEDT
                dataItem.date = dateFLD
                
            }
            PersistenceService.saveContext()
            
        // Checks to see if the switch is selected
        } else if sender.isOn == true {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = UITextField.BorderStyle.roundedRect
                self.titleEDT = cell.titleField.text!
                self.amountEDT = (cell.amountField.text!).removeFormatAmount()
                self.noteEDT = cell.noteField.text!
                dataItem.amount = Double(self.amountEDT)
                dataItem.title = self.titleEDT
                dataItem.note = self.noteEDT
                dataItem.date = dateFLD
                
            }
            
        }
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

extension IncExpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Sets initial position for selector
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // Gets array count
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return months.count
    }
    
    // returns specific selected row.
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     return months[row]
    }
    
    // Provides the data for the selection based on specific month from drop-down
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let fetchRequest: NSFetchRequest<Parent> = Parent.fetchRequest()
        let sortDesc = NSSortDescriptor(keyPath: \Parent.date, ascending: true)
        fetchRequest.sortDescriptors = [sortDesc]
        selectedMonth = months[row]
        monthField.text = selectedMonth
        let arrVal = months.firstIndex(of: selectedMonth)!
        
        let currentDate = Date()
        let calendar = Calendar.current
        let currentYr = calendar.component(.year, from: currentDate)
        let setYr = calendar.date(bySetting: .year, value: currentYr, of: currentDate)!
        let beginCurYear = calendar.dateInterval(of: .year, for: setYr)!.start
        let beginSelMonth = calendar.date(bySetting: .month, value: arrVal + 1, of: beginCurYear)!
        let endSelMonth = calendar.dateInterval(of: .month, for: beginSelMonth)!.end
        fetchRequest.predicate = NSPredicate(format: "date >= %@ && date < %@", beginSelMonth as CVarArg, endSelMonth as CVarArg)

        // Catch block to protect bad data from being retrieved
        do {
            
            let incexpArr = try PersistenceService.context.fetch(fetchRequest)
            self.incexpArr = incexpArr
            
            for item in incexpArr {
                if item.isIncome == true {
                    incomeArr.append(item.amount)
                } else {
                    expenseArr.append(item.amount)
                }
            }
        }
        catch {
            print("fetching failed")
        }
        // Calls function to do the math configuration on what's in the current month
        getMonthAmt()
        selectedIndex = IndexPath(row: -1, section: 0)
        tableView.reloadData()
    }
}

extension UITextField{

@IBInspectable var doneAccessory: Bool{
    get{
        return self.doneAccessory
    }
    set (hasDone) {
        if hasDone{
            addDoneButtonOnKeyboard()
        }
    }
}

func addDoneButtonOnKeyboard()
{
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    doneToolbar.barStyle = .default
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
    
    let items = [flexSpace, done]
    doneToolbar.items = items
    doneToolbar.sizeToFit()
    
    self.inputAccessoryView = doneToolbar
}

    @objc func doneButtonAction()
{
    self.resignFirstResponder()
}
}
