//
//  NotificationNameExtension.swift
//  Budgety
//
//  Created by Matthew Rampey on 3/28/20.
//  Copyright © 2020 Matthew Rampey. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let incomeKey = Notification.Name(rawValue: "incomeNotificationKey")
    static let expenseKey = Notification.Name(rawValue: "expenseNotificationKey")
}
