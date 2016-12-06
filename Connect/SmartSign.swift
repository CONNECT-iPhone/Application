//
//  SmartSign.swift
//  Connect-iPhone
//
//  Created by Youssef Hammoud on 11/11/16.
//  Copyright © 2016 Connect-iPhone. All rights reserved.
//  This class basically views the webview used to display the smartSign video in youtube.
//

import UIKit
import PBWebViewController

class SmartSign: NSObject {
    
    static var navViewController : UINavigationController?
    static var webViewController : PBWebViewController?

    // this function opens the PBWebViewController with the given URL.
    // params: URL to go to
    // params: sender controller.
    static func openUrl(urlString : String, sender : UIViewController) {
        let url = NSURL(string: urlString)
        
        if (SmartSign.webViewController == nil || SmartSign.navViewController == nil)
        {
            SmartSign.webViewController = PBWebViewController()
            SmartSign.navViewController = UINavigationController(rootViewController: SmartSign.webViewController!)
        }
        
        SmartSign.webViewController?.url = url as URL?
        SmartSign.webViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(SmartSign.hide(sender:)))
        SmartSign.webViewController?.title = "Loading..."
        
        sender.present(SmartSign.navViewController!, animated: true, completion: nil)
    }
    
    
    // this function dismisses the navigationBar
    static func hide(sender : AnyObject)
    {
        SmartSign.navViewController?.dismiss(animated: true, completion: { () -> Void in
            SmartSign.webViewController?.url = NSURL(string: "about:blank") as URL?
            SmartSign.webViewController?.load()
        })
    }
}
