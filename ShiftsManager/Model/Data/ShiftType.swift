//
//  ShiftType+CoreDataProperties.swift
//  ShiftsManager
//
//  Created by Luke on 2022/4/3.
//
//

import Foundation
import CoreData

@objc(ShiftType)
public class ShiftType: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShiftType> {
        return NSFetchRequest<ShiftType>(entityName: "ShiftType")
    }

    @NSManaged public var endHour: Int16
    @NSManaged public var endMinute: Int16
    @NSManaged public var hourlyRate: Float
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var remark: String?
    @NSManaged public var restMinute: Int16
    @NSManaged public var startHour: Int16
    @NSManaged public var startMinute: Int16

}

extension ShiftType : Identifiable {

}
