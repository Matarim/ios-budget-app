//
//  Parent+CoreDataProperties.swift
//  Budgety
//
//  Created by Matthew Rampey on 4/6/20.
//  Copyright © 2020 Matthew Rampey. All rights reserved.
//
//

import Foundation
import CoreData


extension Parent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Parent> {
        return NSFetchRequest<Parent>(entityName: "Parent")
    }

    @NSManaged public var title: String?
    @NSManaged public var amount: Double
    @NSManaged public var note: String?
    @NSManaged public var date: Date?
    @NSManaged public var income: NSSet?
    @NSManaged public var expense: NSSet?

}

// MARK: Generated accessors for income
extension Parent {

    @objc(addIncomeObject:)
    @NSManaged public func addToIncome(_ value: Income)

    @objc(removeIncomeObject:)
    @NSManaged public func removeFromIncome(_ value: Income)

    @objc(addIncome:)
    @NSManaged public func addToIncome(_ values: NSSet)

    @objc(removeIncome:)
    @NSManaged public func removeFromIncome(_ values: NSSet)

}

// MARK: Generated accessors for expense
extension Parent {

    @objc(addExpenseObject:)
    @NSManaged public func addToExpense(_ value: Expense)

    @objc(removeExpenseObject:)
    @NSManaged public func removeFromExpense(_ value: Expense)

    @objc(addExpense:)
    @NSManaged public func addToExpense(_ values: NSSet)

    @objc(removeExpense:)
    @NSManaged public func removeFromExpense(_ values: NSSet)

}
