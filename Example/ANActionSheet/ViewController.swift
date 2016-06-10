//
//  ViewController.swift
//  ANActionSheet
//
//  Created by nohirap on 06/05/2016.
//  Copyright (c) 2016 nohirap. All rights reserved.
//

import UIKit
import ANActionSheet

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showActionSheet() {
        
        let actionSheet = ANActionSheet(title: "Title", message: "Message!!!")
        actionSheet.headerBackgroundColor = UIColor.blackColor()
        actionSheet.titleColor = UIColor.redColor()
        actionSheet.messageColor = UIColor.greenColor()
        actionSheet.buttonsBorderColor = UIColor.blackColor()
        let action1 = ANAction(title: "First Button", style: .Default) {
            NSLog("Tap First Button!!!")
        }
        action1.buttonColor = UIColor.redColor()
        actionSheet.addAction(action1)
        
        let action2 = ANAction(title: "Second Button", style: .Default) {
            NSLog("Tap Second Button!!!")
        }
        action2.buttonColor = UIColor.blueColor()
        action2.labelColor = UIColor.greenColor()
        actionSheet.addAction(action2)
        
        let action3 = ANAction(title: "Third Button", style: .Default) {
            NSLog("Tap Third Button!!!")
        }
        action3.buttonColor = UIColor.yellowColor()
        actionSheet.addAction(action3)
        
        let cancelAction = ANAction(title: "Cancel", style: .Cancel)
        cancelAction.labelColor = UIColor.redColor()
        actionSheet.addAction(cancelAction)
        
        actionSheet.show()
    }

    @IBAction func onTouchDownShowButton(sender: AnyObject) {
        showActionSheet()
    }
}

