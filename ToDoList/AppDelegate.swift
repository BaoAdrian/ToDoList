//
//  AppDelegate.swift
//  ToDoList
//
//  Created by Adrian Bao on 6/27/18.
//  Copyright © 2018 Adrian Bao. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    /* Called when application is initially loaded */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Used to test when active
        // print("didFinishLaunchingWithOptions")
        
        // Returns the path the current data is saved into the device
        // print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        return true
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        
        // Used to test when active
        // print("applicationDidEnterBackground")
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        // Used to test when active
        // print("applicationWillTerminate")
        
    }


}

