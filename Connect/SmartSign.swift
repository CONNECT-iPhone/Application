//
//  SmartSign.swift
//  Connect-iPhone
//
//  Created by Youssef Hammoud on 11/11/16.
//  Copyright © 2016 FiveBox. All rights reserved.
//

import UIKit
import PBWebViewController

class SmartSign: NSObject {
    
    static var navViewController : UINavigationController?
    static var webViewController : PBWebViewController?

    static func openUrl(urlString : String, sender : UIViewController) {
        let url = NSURL(string: urlString)
        
        if (SmartSign.webViewController == nil || SmartSign.navViewController == nil)
        {
            SmartSign.webViewController = PBWebViewController()
            SmartSign.navViewController = UINavigationController(rootViewController: SmartSign.webViewController!)
        }
        
        SmartSign.webViewController?.url = url as URL?
        print(SmartSign.webViewController?.url)
        SmartSign.webViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(SmartSign.hide(sender:)))
        SmartSign.webViewController?.title = "Loading..."
        
        sender.present(SmartSign.navViewController!, animated: true, completion: nil)
    }
    
    static func hide(sender : AnyObject)
    {
        SmartSign.navViewController?.dismiss(animated: true, completion: { () -> Void in
            SmartSign.webViewController?.url = NSURL(string: "about:blank") as URL?
            SmartSign.webViewController?.load()
        })
    }
}
