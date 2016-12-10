//
//  ViewController.swift
//  WatchOSApp
//
//  Created by Shahin on 2016-12-09.
//  Copyright © 2016 98%Chimp. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate
{
    @IBOutlet weak var messageLabel: UILabel!
    
    var session: WCSession!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if (WCSession.isSupported())
        {
            session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?)
    {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void)
    {
        if let messageTest = message["Message"] as? String
        {
            messageLabel.text = messageTest
        }
        
        replyHandler(["Reply":"Hello from my iPhone"])

    }
}

