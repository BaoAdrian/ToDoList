//
//  AppDelegate.swift
//  ToDoList
//
//  Created by Adrian Bao on 6/27/18.
//  Copyright © 2018 Adrian Bao. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    /* Called when application is initially loaded */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Location of Realm database (Command + Shift + G within Realm Browser)
        // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        // Creating Realm
        do {
            _ = try Realm()
        } catch {
            print("Error initializing new realm, \(error)")
        }

        return true
        
    }

    
    


}

