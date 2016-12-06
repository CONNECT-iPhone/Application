//
//  HomeViewController.swift
//  Connect-iPhone
//
//  Created by Youssef Hammoud on 9/26/16.
//  Copyright © 2016 Connect-iPhone. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import CoreData
import ASHorizontalScrollView
import Alamofire

// struct to hold the cell identifiers of whether the message is TTS or STT
private struct Constants {
    static let cellIdMessageTTS = "MessageCellTTS"
    static let cellIdMessageSTT = "MessageCellSTT"
}

class HomeViewController: UIViewController, AVSpeechSynthesizerDelegate, SFSpeechRecognizerDelegate,
                        UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    
    // IBOutlets - are objects dragged from the UI
    @IBOutlet weak var message: UITextField!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var quickResponseTableView: UITableView!
    @IBOutlet weak var coversationTableView: UITableView!
    
    //instance variables
    var tField: UITextField!
    let synthesizer = AVSpeechSynthesizer()
    var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    let kCellHeight:CGFloat = 30.0
    var messages = [Message]()
    
    // Create an empty array of LogItem's
    var phrases = [NSManagedObject]()
    var phrasesArray = [String]()
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext


    // put anything you want to see here, so it shows up once the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        quickResponseTableView.dataSource = self
        quickResponseTableView.delegate = self
        quickResponseTableView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        quickResponseTableView.isScrollEnabled = false
        quickResponseTableView.separatorColor = UIColor.clear
        coversationTableView.separatorColor = UIColor.clear
        coversationTableView.allowsSelection = false
        coversationTableView.isUserInteractionEnabled = true
                
        fetchData()
        
        self.navigationItem.title = "STAR"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName: UIFont(name: "Avenir Next Medium", size: 20)!]
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        var tts = UIImage(named: "tts")
        var stt = UIImage(named: "stt")
        tts = tts?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: tts, style: UIBarButtonItemStyle.plain, target: self, action: #selector(HomeViewController.textToSpeechTapped))
        stt = stt?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: stt, style: UIBarButtonItemStyle.plain, target: self, action: #selector(HomeViewController.speechToTextTapped))
        
        
        
        // this block is to authorize the app to use the microphone - has to be done
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization( { (authStatus) in
            var isButtonEnabled = false
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            OperationQueue.main.addOperation() {
                self.navigationItem.rightBarButtonItem?.isEnabled = isButtonEnabled
            }
        })
    }
    
    
    // this fucntion fetches the quick responses from Core Data
    func fetchData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Phrase")
        
        do {
            let results = try self.managedObjectContext.fetch(fetchRequest)
            phrases = results as! [NSManagedObject]
            for phrase in phrases {
                phrasesArray.append(phrase.value(forKey: "text") as! String)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // this fucntion handles the smartSign action
    // after long pressing a word and tapping smartSign, 
    // this is the handler that takes car of the rest and
    // pedirect you the the YouTube video in the webview
    // if the label selected had more than one word, 
    // then we present all the words in the text for the user 
    // in a ActionController so they can pick the word they want.
    func toSmartSign(sender: UIMenuController) {
        let smartSignMenu = sender.menuItems?.first as! SmartSignMenuItem
        let text = smartSignMenu.smartSignText
        print(text.components(separatedBy: " ").count)
        if text.components(separatedBy: " ").count > 1 {
            let optionMenu = UIAlertController(title: nil, message: "Choose word", preferredStyle: .actionSheet)
            for word in text.components(separatedBy: " ") {
                optionMenu.addAction(UIAlertAction(title: word, style: .default) { action -> Void in
                    let url = "https://dictionary-smartsign.rhcloud.com/videos?keywords=\(word)"
                    Alamofire.request(url)
                        .responseJSON { response in
                            let value = (response.result.value as! NSDictionary)
                            let array = value["data"]
                            let dict = (array as! Array<Any>) as! [[String:AnyObject]]
                            let smartSignViewController = self.storyboard?.instantiateViewController(withIdentifier: "smartSignViewController") as! SmartSignViewController
                            smartSignViewController.dict = dict
                            smartSignViewController.word = word
                            self.navigationController?.pushViewController(smartSignViewController, animated: true)
                    }
                })
            }
            self.present(optionMenu, animated: true, completion: nil)
        } else {
            let url = "https://dictionary-smartsign.rhcloud.com/videos?keywords=\(smartSignMenu.smartSignText)"
            Alamofire.request(url)
                .responseJSON { response in
                    let value = (response.result.value as! NSDictionary)
                    let array = value["data"]
                    let dict = (array as! Array<Any>) as! [[String:AnyObject]]
                    let smartSignViewController = self.storyboard?.instantiateViewController(withIdentifier: "smartSignViewController") as! SmartSignViewController
                    smartSignViewController.dict = dict
                    smartSignViewController.word = smartSignMenu.smartSignText
                    self.navigationController?.pushViewController(smartSignViewController, animated: true)
            }
        }

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // hides the keyboard when we tap outside the keyboard/anywhere in the screem.
    func dismissKeyboard() {
        self.message.endEditing(true)
    }
    
    // action triggered when quick response is tapped - speak the button labeled text
    func tapQuickResponseButton(sender: UIButton) {
    
        let string = sender.titleLabel?.text
        let utterance = AVSpeechUtterance(string: string!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.delegate = self
        synthesizer.speak(utterance)
    }
    
    
    
    // action triggered when right nav bar icon is tapped
    func textToSpeechTapped(_ sender :UIBarButtonItem) {
        
        // if the message field is empty, don't convert to speech and show error message
        if ((self.message.text?.isEmpty)!) {
            
            let alert = UIAlertController(title: "Error", message: "Please enter a text to be spoken", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let string = self.message.text!
            synthesizer.delegate = self
            let utterance = AVSpeechUtterance(string: string)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            
            synthesizer.speak(utterance)
        }
    }
    
    // AVSpeechSynthesizerDelegate delegate funtions
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("starting")
    }
    
    // AVSpeechSynthesizerDelegate delegate funtions
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        let message = Message(tts: true, text: self.message.text!)
        messages.append(message)
        self.coversationTableView.reloadData()
        self.message.text = ""
        let index = IndexPath(row: messages.count - 1, section: 0)
        self.coversationTableView.scrollToRow(at: index, at: .bottom, animated: true)
        self.message.endEditing(true)

    }
    
    // AVSpeechSynthesizerDelegate delegate funtions
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: characterRange)
        self.message.attributedText = mutableAttributedString

    }
    
    // the action handler for tapping the speech to text button in the nav bar
    func speechToTextTapped(_ sender :UIBarButtonItem) {
        if audioEngine.isRunning {
            audioEngine.stop()
            self.recognitionRequest?.endAudio()
            let text = self.message.text!
            let m = Message(tts: false, text: text)
            messages.append(m)
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("audioSession properties weren't set because of an error.")
            }
            self.coversationTableView.reloadData()
            self.message.text = ""
            let index = IndexPath(row: messages.count - 1, section: 0)
            self.coversationTableView.scrollToRow(at: index, at: .bottom, animated: true)
        } else {
            startRecordingSpeech()
        }
    }
    
    // function that starts recording the speecj
    func startRecordingSpeech() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.message.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        self.message.text = "Say something, I'm listening!"
    }
    
    // SFSpeechRecognizer delegate funtions

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    
    // action triggered when add+ button is tapped on the bottom bar
    @IBAction func addQuickResponse(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add new quick response", message: "", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler:{ (UIAlertAction) in
            let textField = alert.textFields!.first
            if (textField?.text == nil || (textField?.text?.isEmpty)!) {
                let error = UIAlertController(title: "Error", message: "Please enter a text to be saved", preferredStyle: .alert)
                error.addAction(UIKit.UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.savePhrase(name: textField!.text!)
            }
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    // handler for saving the phrases locally in core data
    func savePhrase(name: String) {
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entity(forEntityName: "Phrase",
                                                 in:managedContext)
        
        let phrase = NSManagedObject(entity: entity!,
                                     insertInto: managedContext)
        
        //3
        phrase.setValue(name, forKey: "text")
        
        //4
        do {
            try managedContext.save()
            //5
            phrases.append(phrase)
            phrasesArray.append(name)
            self.quickResponseTableView.reloadData()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // action triggered when long press any of the quick response buttons - edit or delete a quick response
    func longPressQuickResponseButton(sender: UILongPressGestureRecognizer) {
        let alert = UIAlertController(title: "Edit/Delete Quick Response", message: "Edit text field to edit quick response and tap edit, or tap delete to delete quick response", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (UIAlertAction) in
            let phrase = (sender.view?.subviews.first as! UILabel).text!
            let new = alert.textFields!.first?.text!
            if (new == nil || (new?.isEmpty)!) {
                let error = UIAlertController(title: "Error", message: "Please enter a text to be saved", preferredStyle: .alert)
                error.addAction(UIKit.UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            } else {
                self.updatePhrase(phrase: phrase, new: new!)
            }
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler:{ (UIAlertAction) in
            let phrase = (sender.view?.subviews.first as! UILabel).text!
            self.deletePhrase(phrase: phrase)
        }))
        self.present(alert, animated: true, completion: {
        })
        
    }

    // handler for deleting phrases from core data
    func deletePhrase(phrase: String) {
        let i = phrasesArray.index(of: phrase)
        let toDelete = phrases[i!]
        self.managedObjectContext.delete(toDelete)
        
        do {
            try self.managedObjectContext.save()
            phrasesArray.remove(at: i!)
            self.quickResponseTableView.reloadData()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
    
    // handler for updating phrase in core date
    func updatePhrase(phrase: String, new: String) {
        let i = phrasesArray.index(of: phrase)
        let toUpdate = phrases[i!] 
        toUpdate.setValue(new, forKey: "text")
        
        do {
            try toUpdate.managedObjectContext?.save()
            phrasesArray[i!] = new
            self.quickResponseTableView.reloadData()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
        
    }
    
    // handler for getting the text entered in AlertViewController text fields (quick responses)
    func configurationTextField(_ textField: UITextField!)
    {
        textField.placeholder = "Enter an item"
        tField = textField
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.quickResponseTableView.reloadData()
        
    }
    // table view delegates and data source funtions
    // handles viewing the data on the conversation view and the quick responses
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (tableView.isEqual(self.coversationTableView)) {
            let m = messages[indexPath.row]
            let isTTS = m.tts
            let content = m.text
            if (isTTS) {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdMessageTTS, for: indexPath) as! ConversationTableViewCell
                cell.configCell(message: content)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdMessageSTT, for: indexPath) as! ConversationTableViewCell
                cell.configCell(message: content)
                return cell
            }
        } else if (tableView.isEqual(self.quickResponseTableView)) {
            let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "CellPortrait")
            let horizontalScrollView:ASHorizontalScrollView = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: kCellHeight))
            
            horizontalScrollView.miniAppearPxOfLastItem = 10
            horizontalScrollView.uniformItemSize = CGSize(width: 100, height: 50)
            for i in 0..<phrasesArray.count {
                let button = UIButton(frame: CGRect.zero)
                button.backgroundColor = UIColor.lightGray
                let title = phrasesArray[i]
                button.setTitle(title as String?, for: .normal)
                button.titleLabel?.textColor = UIColor.white
                button.titleLabel!.adjustsFontSizeToFitWidth = true
                horizontalScrollView.addItem(button)
                let view = horizontalScrollView.items.last
                view?.layer.cornerRadius = 20
                view?.layer.masksToBounds = true
                button.addTarget(self, action: #selector(HomeViewController.tapQuickResponseButton), for: .touchUpInside)
                button.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(HomeViewController.longPressQuickResponseButton)))
            }
            
            cell.contentView.addSubview(horizontalScrollView)
            horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: kCellHeight))
            cell.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
            
            
            return cell
        }

        return tableView.dequeueReusableCell(withIdentifier: "CellPortrait")!

    }
    
    // returns the number of sections in the table view
    func tableView(_ tableView: UITableView, numberOfSections section: Int) -> Int {
        return 1
    }
    
    // returns the number of rows in each section in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.isEqual(self.coversationTableView)) {
            return messages.count
            
        } else {
            return 1
        }
    }
    
    // returns the height of each row at any index path in the table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView.isEqual(self.coversationTableView)) {
            return UITableViewAutomaticDimension
            
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }


}
