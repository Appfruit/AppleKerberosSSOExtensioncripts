#!/usr/bin/swift

//title          :DistributedNotificationListener.swift.sh
//description    :This script can be run to lsiten for macOS distributed notifications and then execute a script
//               :This script is developed by the example Apple provides in their Kerberos SSO Extension guide.
//author         :Fabian Hartmann
//date           :2020-11-13
//version        :0.1
// Sources       :https://www.apple.com/business/docs/site/Kerberos_Single_Sign_on_Extension_User_Guide.pdf
//============================================================================



//============================================================================
//# Revision History:
//#
//#    Date          Version            Personnel                Notes
//#    ----          -------            ----------------    -----
//#   2020-11-13      0.1              Fabian Hartmann   Script created
//============================================================================
//

import Foundation; import AppKit

class NotifyHandler {
    // variables are defined
    var notification: String
    var action: String
    
    // variables are set
    init(notification: String, action: String) {
        self.notification = notification
        self.action = action }
    
    // the function monitors for the configured notification
    func observe() { DistributedNotificationCenter.default.addObserver(
        forName: Notification.Name(notification), object: nil,
        queue: nil,
        // if fount it execudes the funcition gotNotification
        using: self.gotNotification(notification:)
    ) }
    
    // this function runs the specified script and gets called if observe() has found a notification.
    func gotNotification(notification: Notification) { let task = Process()
        task.launchPath = "/bin/zsh"; task.arguments = ["-c", self.action]; task.launch()
    }
}

let app = NSApplication.shared

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // defines the path to this script itselve
        let scriptPath: String = CommandLine.arguments.first!
        
        // reads the configured notification by retriving the input for attribute notifications. If not specified, it prints the error and exits.
        guard let notificationName = UserDefaults.standard.string(forKey: "notification") else {
            print("\(scriptPath): No notification passed, exiting...")
            exit(1) }
        
        // reads the configured path for the script to run by retriving the input for attribute action. If not specified, it prints the error and exits.
        guard let actionPath = UserDefaults.standard.string(forKey: "action") else { print("\(scriptPath): No action passed, exiting...")
            exit(1)
        }
        // if notification and action is configured, the NotifyHandler class is called.
        let nh = NotifyHandler.init(notification: notificationName, action: actionPath); nh.observe()
    }
}

let delegate = AppDelegate(); app.delegate = delegate; app.run()
 
