<snippet>
  <content>
# CONNECT-iPhone

Today, communication is difficult for the deaf. Ninety percent of deaf kids have hearing parents and of those, only about twenty percent know sign language; communication between them is usually very limited, if not impossible. The connect iOS app bridges this gap and enables two-way communication by converting both speech to text and text back to speech. Integration with the SmartSign dictionary also allows users to learn sign language by showing them how to sign certain words.

## Release Notes
  Software Features in this Release:<br />
   * SmartSign Integration<br />
  Bug Fixes from Last Release:<br />
   * Can now do both speech-to-text and text-to-speech without app crashing<br />
  Known Bugs and Defects:<br />
   * If you type a really long quick phrase, the newly added quick phrase text at the bottom would decrease in size immensely to fit in the allotted space.<br />
   * If you add a quick phrase that was already there, it will still add the quick phrase. The quick phrases at the bottom, should only add unique quick phrases.
  
## Install Guide

### PRE-REQUISITES
  You will need to have Mac OSX with XCode 8 and Swift 3. The reason we are using Swift 3 is because Apple added the Speech     recognition library to the SDK and we used that in our development. In order to run the app on an iPhone device, you will     need to sign in to your Apple Developer account and select a registered device to run the app on. If you do not have an       AppleDeveloper account, you can either create one, or just run the app on the simulator. The speech to text feature will not    work in the simulator because the simulator does not have access to a microphone to record the speech.

### DEPENDENCIES
  We used CocoaPods to use existing libraries. If you don't know whether you have CocoaPods intalled on your computer or not, type `pod` in terminal, if it shows an error, then you don't have it installed. To install Cocoapods, simpley do this in terminal <br/>
  `sudo gem install cocoapods` <br/>
  Here is additional information about cocoapods https://cocoapods.org/
  
### DOWNLOAD INSTRUCTIONS
  TODO: how will the customer and users get access to the project?
  Once you have Xcode 8, Swift 3 and CocoaPods installed on your computer, download this project on your machine. Then simply go to terminal and navigate to the priject folder. In the project folder do `pod install` to make sure all pods are installed.

### BUILD INSTRUCTIONS
  TODO: only if needed. DELETE section if not needed.
  Now you have everything you need to open the project. In terminal you can do <br/>
  `open Connect-iPhone.xcworkspace`<br/>
  This command will basically open the Xcode workspace for the Connect-iPhone project.
  To build the application, you will need to do `Command + B` or from the menu `Product>Build`.

### RUN INSTRUCTIONS
  TODO: what does the user/customer actually have to do to get the software to execute
  To run the application on a simulator, you will need to select (add) a simulator in Xcode, then click on the play button.
  To run the app on an iPhone device, make sure you have an AppleDeveloper Account and you have an iPhone device connected to the computer via USB cable. Then go to the Targets and select `Connect-iPhone`, then make sure you have your account in signing section (under General tab) with your registered device. Then go ahead and click on the play button to install the app build on your device and run it.

### TROUBLESHOOTING
  TODO: what are common errors that occur during installation and what is the corrective action
  Common errors that might happen are: <br/>
  * probelms with building the project after installation. Make sure you are opening the `Connect-iPhone.xcworkspace` not `Connect-iPhone.xcodeproj`
  * Getting the app to run on the device. The best place to find the solution for this is the AppleDevelopers website https://developer.apple.com/

## CONTRIBUTING TO THE SOURCE CODE INSTRUCTIONS
  1. Fork it! <br />
  2. Create your feature branch: `git checkout -b my-new-feature` <br />
  3. Commit your changes: `git commit -am 'Add some feature'` <br />
  4. Push to the branch: `git push origin my-new-feature` <br />
  5. Submit a pull request :D <br />


## CREDITS
  Georgia Institute of Technology Senior Design Application Fall 2016 <br />
  Casey Bennett <br />
  Sidney Durant <br />
  Youssef Hammoud <br />
  Tina Ho <br />
  Zurie Mai <br />
  </content>
</snippet>

