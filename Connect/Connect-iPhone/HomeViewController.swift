//
//  HomeViewController.swift
//  Connect-iPhone
//
//  Created by Youssef Hammoud on 9/26/16.
//  Copyright © 2016 FiveBox. All rights reserved.
//

import UIKit
import AVFoundation
import Speech


class HomeViewController: UIViewController, AVSpeechSynthesizerDelegate, SFSpeechRecognizerDelegate {

    
    // IBOutlets - are objects dragged from the UI
    @IBOutlet weak var conversation: UIView!
    @IBOutlet weak var message: UITextField!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var quickResponseDemo: UIButton!
    
    //instance variables
    var tField: UITextField!
    var synthesizer = AVSpeechSynthesizer()
    var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()


    // put anything you want to see here, so it shows up once the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Connect"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName: UIFont(name: "Avenir Next Medium", size: 20)!]
        
        
        var tts = UIImage(named: "tts")
        var stt = UIImage(named: "stt")
        tts = tts?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: tts, style: UIBarButtonItemStyle.plain, target: self, action: #selector(HomeViewController.textToSpeechTapped))
        stt = stt?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: stt, style: UIBarButtonItemStyle.plain, target: self, action: #selector(HomeViewController.speechToTextTapped))
        
        self.synthesizer.delegate = self
        
        
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
        

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tapQuickResponseButton))  //Tap function will call when user tap on button
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(HomeViewController.longPressQuickResponseButton)) //Long function will call when user long press on button.
        tapGesture.numberOfTapsRequired = 1
        self.quickResponseDemo.addGestureRecognizer(tapGesture)
        self.quickResponseDemo.addGestureRecognizer(longGesture)
        
        // Do any additional setup after loading the view.
    }
    
    // ignore this for now
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    // ignore this for now
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // action triggered when quick response is tapped - speak the button labeled text
    func tapQuickResponseButton(){
        let string = self.quickResponseDemo.titleLabel?.text
        let utterance = AVSpeechUtterance(string: string!)
        
        synthesizer.speak(utterance)
    }
    
    
    // action triggered when long press any of the quick response buttons - edit or delete a quick response
    func longPressQuickResponseButton() {
        let alert = UIAlertController(title: "Edit/Delete Quick Response", message: "Edit text field to edit quick response and tap edit, or tap delete to delete quick response", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Edit", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler:{ (UIAlertAction) in
            print("Done !!")
            
            print("Item : \(self.tField.text)")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })

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
            let utterance = AVSpeechUtterance(string: string)
            synthesizer.speak(utterance)
        }
    }
    
    // AVSpeechSynthesizerDelegate delegate funtions
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
    // AVSpeechSynthesizerDelegate delegate funtions end
    
    func speechToTextTapped(_ sender :UIBarButtonItem) {
        if audioEngine.isRunning {
            audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            startRecordingSpeech()
        }
    }
    
    func startRecordingSpeech() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
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
            
        }))
        self.present(alert, animated: true, completion: {
        })

    }
    
    
    func configurationTextField(_ textField: UITextField!)
    {
        textField.placeholder = "Enter an item"
        tField = textField
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
