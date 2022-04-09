//
//  ShiftDate+CoreDataProperties.swift
//  ShiftsManager
//
//  Created by Luke on 2022/4/3.
//
//

import Foundation
import CoreData

@objc(ShiftDate)
public class ShiftDate: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShiftDate> {
        return NSFetchRequest<ShiftDate>(entityName: "ShiftDate")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var typeId: String?
    
    public override func awakeFromInsert() {
        id = UUID().uuidString
    }

}

extension ShiftDate : Identifiable {

}
