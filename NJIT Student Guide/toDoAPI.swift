//
//  toDoAPI.swift
//  NJIT Student Guide
//
//  Created by Venkatesh Muthukrishnan on 12/2/15.
//  Copyright © 2015 Fantastic4. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class toDoAPI {
    class var sharedInstance : toDoAPI {
        struct Singleton {
            static let instance = toDoAPI()
        }
        return Singleton.instance
    }
    
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func insert(item: String! , tick: String!)->Bool{
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let record = NSEntityDescription.insertNewObjectForEntityForName("ToDoModel", inManagedObjectContext: context)
        record.setValue(item, forKey: "items")
        record.setValue(tick, forKey: "tick")
        do {
            try context.save()
            return true
        }catch {
            print("not saved")
            return false
        }
    
}
}