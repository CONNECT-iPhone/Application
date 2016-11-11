//
//  Phrase.swift
//  Connect-iPhone
//
//  Created by Youssef Hammoud on 11/7/16.
//  Copyright © 2016 FiveBox. All rights reserved.
//

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
