//
//  Physician+CoreDataProperties.swift
//  DoctorsAppointments
//
//  Created by Mazharul Huq on 2/23/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//
//

import Foundation
import CoreData


extension Physician {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Physician> {
        return NSFetchRequest<Physician>(entityName: "Physician")
    }

    @NSManaged public var name: String?
    @NSManaged public var practice: String?
    @NSManaged public var specialty: String?
    @NSManaged public var appointments: NSOrderedSet?

}

// MARK: Generated accessors for appointments
extension Physician {

    @objc(insertObject:inAppointmentsAtIndex:)
    @NSManaged public func insertIntoAppointments(_ value: Appointment, at idx: Int)

    @objc(removeObjectFromAppointmentsAtIndex:)
    @NSManaged public func removeFromAppointments(at idx: Int)

    @objc(insertAppointments:atIndexes:)
    @NSManaged public func insertIntoAppointments(_ values: [Appointment], at indexes: NSIndexSet)

    @objc(removeAppointmentsAtIndexes:)
    @NSManaged public func removeFromAppointments(at indexes: NSIndexSet)

    @objc(replaceObjectInAppointmentsAtIndex:withObject:)
    @NSManaged public func replaceAppointments(at idx: Int, with value: Appointment)

    @objc(replaceAppointmentsAtIndexes:withAppointments:)
    @NSManaged public func replaceAppointments(at indexes: NSIndexSet, with values: [Appointment])

    @objc(addAppointmentsObject:)
    @NSManaged public func addToAppointments(_ value: Appointment)

    @objc(removeAppointmentsObject:)
    @NSManaged public func removeFromAppointments(_ value: Appointment)

    @objc(addAppointments:)
    @NSManaged public func addToAppointments(_ values: NSOrderedSet)

    @objc(removeAppointments:)
    @NSManaged public func removeFromAppointments(_ values: NSOrderedSet)

}
