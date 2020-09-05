//
//  AppDelegate.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/10/20.
//

import Cocoa
import SwiftUI
import Firebase

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
        
        // Start required services
        FirebaseApp.configure()
        GCDServer.startup()
        let _ = try? Auth.auth().signOut()
        Auth.auth().signIn(withEmail: "josephpaul3820@gmail.com", password: "Testpassword1!") { (result, err) in
            if let err = err {
                LoggingManager.log(err.localizedDescription)
            }
            print("🟣 \(Auth.auth().currentUser?.email)")
        }

        // Create the window
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 700, height: 600),
            styleMask: [.titled, .closable],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.title = "StockManagerServerApplication"
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

