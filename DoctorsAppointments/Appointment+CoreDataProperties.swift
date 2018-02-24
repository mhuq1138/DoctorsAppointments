//
//  Appointment+CoreDataProperties.swift
//  DoctorsAppointments
//
//  Created by Mazharul Huq on 2/23/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//
//

import Foundation
import CoreData


extension Appointment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Appointment> {
        return NSFetchRequest<Appointment>(entityName: "Appointment")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var physician: Physician?

}
