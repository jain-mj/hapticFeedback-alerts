//
//  ViewController.swift
//  Vibration Feedbacks
//
//  Created by Mukul Jain
//  Copyright © 2017 jain_mj. All rights reserved.
//

import UIKit
import AudioToolbox
import SystemConfiguration

enum ENotificationFeedbackType: Int
{
    case success = 0
    case error
    case warning
}

enum EImpactFeedbackType: Int
{
    case lightImpact = 0
    case mediumImpact
    case heavyImpact
}

class ViewController: UIViewController
{
    // MARK:- VC Life cycle methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Get the current Device Name
        print ("The current device is:- \(UIDevice.current.modelName)")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- Method to check the device type
    
    func checkPlatformIsSimulator() -> Bool
    {
        var isSimulator = false
        #if(arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
            isSimulator = true
        #endif
        return isSimulator
    }
    
    // MARK:- Notification Feedbacks Button Actions
    
    @IBAction func successFeedback(_ sender: AnyObject)
    {
        self.generateNotificationFeedabck(type: .success)
    }
    
    @IBAction func errorFeedback(_ sender: AnyObject)
    {
        self.generateNotificationFeedabck(type: .error)
    }
    
    @IBAction func warningFeedback(_ sender: AnyObject)
    {
        self.generateNotificationFeedabck(type: .warning)
    }
    
    // MARK:- Impact Feedbacks Button Actions
    
    @IBAction func lightImpactFeedback(_ sender: AnyObject)
    {
        self.generateImpactFeedabck(type: .lightImpact)
        
    }
    
    @IBAction func mediumImpactFeedback(_ sender: AnyObject)
    {
        self.generateImpactFeedabck(type: .mediumImpact)
    }
    
    @IBAction func heavyImpactFeedback(_ sender: AnyObject)
    {
        self.generateImpactFeedabck(type: .heavyImpact)
    }
    
    // MARK:- Selection Feedback
    
    @IBAction func selectionFeedback(_ sender: AnyObject)
    {
        if ( !self.checkPlatformIsSimulator() )
        {
            if #available(iOS 10.0, *)
            {
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
            }
            else
            {
                // Fallback on earlier versions
                self.generateSimpleVibrationFeedback()
            }
        }
    }
    
    // Available through Audio Tool Kit supports older version of iOS
    
    @IBAction func simpleVibrationFeedback (_ sender: AnyObject)
    {
        if ( !self.checkPlatformIsSimulator() )
        {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
    }
    
    
    /*
     *  MARK:- Haptic Feedbck methods
     *  Available only from iOS 10 (iphone 7)
     *
     */
    
    
    // MARK:- Notification Feedbacks
    
    func generateNotificationFeedabck (type: ENotificationFeedbackType)
    {
        if ( !self.checkPlatformIsSimulator() )
        {
            // Check whether device supports the Haptic feedbacks or not
            guard #available(iOS 10.0, *)
                else
            {
                self.generateSimpleVibrationFeedback()
                return
            }
            
            // Notification Haptic Feedback
            let generator = UINotificationFeedbackGenerator()
            switch type
            {
            case .error:
                generator.notificationOccurred(.error)
                break
                
            case .success:
                generator.notificationOccurred(.success)
                break
                
            case .warning:
                generator.notificationOccurred(.warning)
                break
            }
        }
    }
    
    // MARK:- Impact Feedbacks
    
    func generateImpactFeedabck (type: EImpactFeedbackType)
    {
        if ( !self.checkPlatformIsSimulator() )
        {
            // Check whether device supports the Haptic feedbacks or not
            guard #available(iOS 10.0, *)
                else
            {
                self.generateSimpleVibrationFeedback()
                return
            }
            
            // Impact Haptic Feedback
            var generator: UIImpactFeedbackGenerator
            
            switch type
            {
            case .lightImpact:
                generator = UIImpactFeedbackGenerator(style: .light)
                break
                
            case .mediumImpact:
                generator = UIImpactFeedbackGenerator(style: .medium)
                break
                
            case .heavyImpact:
                generator = UIImpactFeedbackGenerator(style: .heavy)
                break
            }
            generator.impactOccurred()
        }
    }
    
    // MARK:- Simple Vibration Feedback thorugh AudioToolbox
    
    func generateSimpleVibrationFeedback ()
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        // Show an alert denoting that normal vibration feedback is genearted as device doesn't support Haptics
        
        let alert = UIAlertController(title: "Vibration Feedback", message: "Simple Vibration Feedback generated....\nDue to un-supported device for Haptics.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

