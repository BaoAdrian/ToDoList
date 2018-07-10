//
//  Item.swift
//  ToDoList
//
//  Created by Adrian Bao on 7/7/18.
//  Copyright © 2018 Adrian Bao. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    // This links the categories to specific objects linked by the string "items"
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
    
}


