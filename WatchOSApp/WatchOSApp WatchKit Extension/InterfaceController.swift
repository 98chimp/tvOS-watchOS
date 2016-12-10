//
//  InterfaceController.swift
//  WatchOSApp WatchKit Extension
//
//  Created by Shahin on 2016-12-09.
//  Copyright © 2016 98%Chimp. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate
{

    @IBOutlet var sentText: WKInterfaceLabel!
    
    var session: WCSession!
    
    override func awake(withContext context: Any?)
    {
        super.awake(withContext: context)
        
        sentText.setText("Welcome iPhone from Watch")
    }
    
    override func willActivate() {
        super.willActivate()
        
        if (WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self
            session.activate()
        }

    }
    
    @IBAction func sendText()
    {
        let messageToSend = ["Message":"Welcome iPhone from Watch"]
        
        session.sendMessage(messageToSend, replyHandler: { (replyDict) -> Void in
            
            if let replyText = replyDict["Reply"] as? String {
                self.sentText.setText(replyText)
            }
            
        }) { (error) -> Void in }
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?)
    {
        
    }

}
