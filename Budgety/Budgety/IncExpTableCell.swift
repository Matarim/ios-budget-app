//
//  ExpTableCell.swift
//  Budgety
//
//  Created by Matthew Rampey on 4/5/20.
//  Copyright © 2020 Matthew Rampey. All rights reserved.
//

import UIKit

class IncExpTableCell: UITableViewCell {

    // MARK: - Properties

    static let reuseIdentifier = "cell"

    // MARK: -

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var notesLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
