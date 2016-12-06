//
//  Phrase.swift
//  Connect-iPhone
//
//  Created by Youssef Hammoud on 11/7/16.
//  Copyright © 2016 FiveBox. All rights reserved.

//  Phrase object is used to store the text of the quick responses that will be used to store the text in the core data local database

import UIKit
import CoreData
import Foundation

class Phrase: NSManagedObject {
    @NSManaged var text: String
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, text: String) -> Phrase {
        let newPhrase = NSEntityDescription.insertNewObject(forEntityName: "LogItem", into: moc) as! Phrase
        newPhrase.text = text
    
        return newPhrase
    }

}
