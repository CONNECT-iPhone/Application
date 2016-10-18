//
//  HomeViewController.swift
//  Connect-iPhone
//
//  Created by Youssef Hammoud on 9/26/16.
//  Copyright © 2016 FiveBox. All rights reserved.
//

import UIKit
import AVFoundation


class HomeViewController: UIViewController, AVSpeechSynthesizerDelegate {

    
    
    @IBOutlet weak var conversation: UIView!
    @IBOutlet weak var message: UITextField!
    @IBOutlet weak var add: UIButton!
    var tField: UITextField!
    var synthesizer = AVSpeechSynthesizer()

    @IBOutlet weak var quickResponseDemo: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.delegate = self
        self.navigationItem.title = "Connect"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName: UIFont(name: "Avenir Next Medium", size: 20)!]
        
        
        var tts = UIImage(named: "tts")
        var stt = UIImage(named: "stt")

        tts = tts?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: tts, style: UIBarButtonItemStyle.plain, target: self, action: #selector(HomeViewController.textToSpeechTapped))
        stt = stt?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: stt, style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tapQuickResponseButton))  //Tap function will call when user tap on button
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(HomeViewController.longPressQuickResponseButton)) //Long function will call when user long press on button.
        tapGesture.numberOfTapsRequired = 1
        self.quickResponseDemo.addGestureRecognizer(tapGesture)
        self.quickResponseDemo.addGestureRecognizer(longGesture)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapQuickResponseButton(){
        let string = self.quickResponseDemo.titleLabel?.text
        let utterance = AVSpeechUtterance(string: string!)
        
        synthesizer.speak(utterance)
    }
    
    func longPressQuickResponseButton() {
        let alert = UIAlertController(title: "Edit/Delete Quick Response", message: "Edit text field to edit quick response and tap edit, or tap delete to delete quick response", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Edit", style: .cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler:{ (UIAlertAction) in
            print("Done !!")
            
            print("Item : \(self.tField.text)")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })

    }
    
    func textToSpeechTapped(_ sender :UIBarButtonItem) {
        
        if ((self.message.text?.isEmpty)!) {
            
            let alert = UIAlertController(title: "Error", message: "Please enter a text to be spoken", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let string = self.message.text!
            let utterance = AVSpeechUtterance(string: string)
            
            synthesizer.speak(utterance)
            
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("starting")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("finished")
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: characterRange)
        self.message.attributedText = mutableAttributedString

    }
    
    


 
    
    @IBAction func addQuickResponse(_ sender: UIButton) {
        
        

        let alert = UIAlertController(title: "Add new quick response", message: "", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler:{ (UIAlertAction) in
            print("Done !!")
            
            print("Item : \(self.tField.text)")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })

    }
    
    func configurationTextField(_ textField: UITextField!)
    {
        print("generating the TextField")
        textField.placeholder = "Enter an item"
        tField = textField
    }
    
    func handleCancel(_ alertView: UIAlertAction!)
    {
        print("Cancelled !!")
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
