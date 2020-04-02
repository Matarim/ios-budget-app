//
//  Expense+CoreDataProperties.swift
//  Budgety
//
//  Created by Matthew Rampey on 4/1/20.
//  Copyright © 2020 Matthew Rampey. All rights reserved.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var title: String?
    @NSManaged public var amount: Double
    @NSManaged public var note: String?
    @NSManaged public var date: Date?

}
