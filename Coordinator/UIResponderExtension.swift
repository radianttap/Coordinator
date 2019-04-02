//
//  UIResponderExtension.swift
//  Coordinator
//
//  Created by Marc Zhao on 2019/4/1.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit


/**
 Driving engine of the message passing through the app, with no need for Delegate pattern nor Singletons.
 
 It piggy-backs on the UIResponder.next? in order to pass the message through UIView/UIVC hierarchy of any depth and complexity.
 However, it does not interfere with the regular UIResponder functionality.
 
 At the UIViewController level (see below), it‘s intercepted to switch up to the coordinator, if the UIVC has one.
 Once that happens, it stays in the Coordinator hierarchy, since coordinator can be nested only inside other coordinators.
 */
public extension UIResponder {
    @objc var coordinatingResponder: UIResponder? {
        return next
    }
    
    /*
     // sort-of implementation of the custom message/command to put into your Coordinable extension
     
     func messageTemplate(args: Whatever, sender: Any?) {
     coordinatingResponder?.messageTemplate(args: args, sender: sender)
     }
     */
}

