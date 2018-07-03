//
//  Item.swift
//  ToDoList
//
//  Created by Adrian Bao on 7/2/18.
//  Copyright © 2018 Adrian Bao. All rights reserved.
//

import Foundation

// Conforms to protocols set by Encodable
class Item: Codable /* Codable replaces Encodable & Decodable */ {
    
    // Item Attributes
    var title: String = ""
    var done: Bool = false
    
    
    
}
