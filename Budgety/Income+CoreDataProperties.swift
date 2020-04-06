//
//  Income+CoreDataProperties.swift
//  Budgety
//
//  Created by Matthew Rampey on 4/6/20.
//  Copyright © 2020 Matthew Rampey. All rights reserved.
//
//

import Foundation
import CoreData


extension Income {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Income> {
        return NSFetchRequest<Income>(entityName: "Income")
    }

    @NSManaged public var parent: Parent?

}
