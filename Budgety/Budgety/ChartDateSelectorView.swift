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
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(ChartDateSelectorView.dateChanged(datePicker:)), for: .valueChanged)
        

        startDate.inputView = datePicker
        endDate.inputView = datePicker
        

    }
    
    @IBAction func viewButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        startDate.text = dateFormatter.string(from: datePicker.date)
        endDate.text = dateFormatter.string(from: datePicker.date)
        //Undecided if this is wanted because it essentially auto closes the date picker potentially before the selection was finished....
        //view.endEditing(true)
    }
    
    
}
