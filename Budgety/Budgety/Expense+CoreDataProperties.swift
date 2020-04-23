//
//  Expense+CoreDataProperties.swift
//  Budgety
//
//  Created by Matthew Rampey on 4/6/20.
//  Copyright © 2020 Matthew Rampey. All rights reserved.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var parent: Parent?

}
