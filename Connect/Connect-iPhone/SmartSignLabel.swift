//
//  SmartSignLabel.swift
//  Connect-iPhone
//
//  Created by Youssef Hammoud on 11/24/16.
//  Copyright © 2016 Connect-iPhone. All rights reserved.
//

import Foundation
import UIKit

class SmartSignLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    func sharedInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu)))
    }
    
    func showMenu(sender: AnyObject?) {
        becomeFirstResponder()
        let smartSign = SmartSignMenuItem(title: "SmartSign", action: #selector(HomeViewController.toSmartSign), text: self.text!)
        UIMenuController.shared.menuItems = [smartSign]
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.setTargetRect(bounds, in: self)
            menu.setMenuVisible(true, animated: true)
        }
        
    }
    
    func smartSign(sender: AnyObject?) {
        
    }
    
    func getWordsInText() -> [String] {
        return (self.text?.components(separatedBy: CharacterSet(charactersIn: " ,!?.")))!
    }
    
    
//    func copy(sender: AnyObject?) {
//        let board = UIPasteboard.general
////        board.string = text
////        let menu = UIMenuController.shared
////        menu.setMenuVisible(false, animated: true)
//    }
    
    
    override var canBecomeFirstResponder: Bool { return true }
    
    func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy) {
            return true
        }
        return false
    }
    
}
