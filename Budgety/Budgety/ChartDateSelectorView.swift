//
//  ChartDateSelectorView.swift
//  Budgety
//
//  Created by Matthew W. Rampey on 4/16/20.
//  Copyright © 2020 Matthew Rampey. All rights reserved.
//

import UIKit

class ChartDateSelectorView: UIViewController {
    
    private var datePicker: UIDatePicker?
    private var datePicker2: UIDatePicker?
    let dateFormatter = DateFormatter()
    let dateFormatter2 = DateFormatter()
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        datePicker = UIDatePicker()
        datePicker2 = UIDatePicker()
        textFieldFinder(startDate)
        textFieldFinder(endDate)
        /*datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(ChartDateSelectorView.dateChanged(datePicker:)), for: .valueChanged)
        */
        startDate.inputView = datePicker
        endDate.inputView = datePicker2

    }
    
    @IBAction func viewButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func textFieldFinder(_ textField: UITextField) {
        if textField == startDate {
            datePicker?.datePickerMode = .date
            datePicker?.addTarget(self, action: #selector(ChartDateSelectorView.startDateChanged(datePicker:)), for: .valueChanged)
        } else if textField == endDate {
            datePicker2?.datePickerMode = .date
            datePicker2?.addTarget(self, action: #selector(ChartDateSelectorView.endDateChanged(datePicker2:)), for: .valueChanged)
        }
    }
    
    @objc func startDateChanged(datePicker: UIDatePicker) {

        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        startDate.text = dateFormatter.string(from: datePicker.date)

        //Undecided if this is wanted because it essentially auto closes the date picker potentially before the selection was finished....
        //view.endEditing(true)
    }
    
    @objc func endDateChanged(datePicker2: UIDatePicker) {

        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        endDate.text = dateFormatter.string(from: datePicker2.date)
        
        //Undecided if this is wanted because it essentially auto closes the date picker potentially before the selection was finished....
        //view.endEditing(true)
    }
    
    
}
