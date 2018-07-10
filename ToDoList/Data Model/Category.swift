//
//  Category.swift
//  ToDoList
//
//  Created by Adrian Bao on 7/7/18.
//  Copyright © 2018 Adrian Bao. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Category : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var bgColor : String = ""
    
    let items = List<Item>()
    
}
