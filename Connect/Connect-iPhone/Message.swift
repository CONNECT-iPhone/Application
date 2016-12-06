//
//  Message.swift
//  Connect-iPhone
//
//  Created by Youssef Hammoud on 11/18/16.
//  Copyright © 2016 Connect-iPhone. All rights reserved.


//  message class is used to locally store the messages to be used in the conversationtableview. 


import Foundation

class Message: NSObject {
    var tts: Bool
    var text: String
    
    init(tts: Bool, text: String) {
        self.tts = tts
        self.text = text
    }
    
        
}
