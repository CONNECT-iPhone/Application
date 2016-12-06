//
//  SmartSignViewController.swift
//  Connect-iPhone
//
//  Created by Youssef Hammoud on 11/26/16.
//  Copyright © 2016 Connect-iPhone. All rights reserved.
//  table view to view the multipule meanings to the same word
//

import UIKit

class SmartSignViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var dict: [[String:AnyObject]] = []
    var word = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // delegate funtions
    // configures a cell and returns it
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SmartSignTableViewCell
        let title = dict[indexPath.row]["title"]
        cell.configCell(word: self.word, title: title as! String)
        return cell
        
        
    }
    
    // detects if a row has been selected in a the table view and acts upon the detection.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let smartSignID = dict[indexPath.row]["id"] as! String
        print(smartSignID)
        let url = "http://www.youtube.com/embed/\(smartSignID)?rel=0&showinfo=0&controls=1&autoplay=1"
        print(url)
        SmartSign.openUrl(urlString: url, sender: self)

    }
    
    // number of sections in the table view
    func tableView(_ tableView: UITableView, numberOfSections section: Int) -> Int {
        return 1
    }
    // number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dict.count
    }
    
    
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
