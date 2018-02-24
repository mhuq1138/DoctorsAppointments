//
//  Appointment+CoreDataClass.swift
//  DoctorsAppointments
//
//  Created by Mazharul Huq on 2/23/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Appointment)
public class Appointment: NSManagedObject {
    func save(_ context:NSManagedObjectContext)-> Bool{
        var saved = false
        if context.hasChanges{
            do {
                try context.save()
                saved = true
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        return saved
    }
    
    func delete(_ context:NSManagedObjectContext)-> Bool{
        var delete = false
        context.delete(self)
        if context.hasChanges{
            do {
                try context.save()
                delete = true
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        return delete
    }


}
