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

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var startTime: Date
    @NSManaged public var endTime: Date
    @NSManaged public var restMinute: Int16
    @NSManaged public var hourlyRate: Float
    @NSManaged public var remark: String?
    
    public override func awakeFromInsert() {
        id = UUID().uuidString
    }

}

extension ShiftType : Identifiable {

}
