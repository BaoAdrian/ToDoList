//
//  Category.swift
//  ToDoList
//
//  Created by Adrian Bao on 7/7/18.
//  Copyright © 2018 Adrian Bao. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    
    let items = List<Item>()
    
}
