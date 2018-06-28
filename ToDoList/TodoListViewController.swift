//
//  ViewController.swift
//  ToDoList
//
//  Created by Adrian Bao on 6/27/18.
//  Copyright © 2018 Adrian Bao. All rights reserved.
//

import UIKit

// Inheriting UITableViewController takes care of delegate and data source responsibilities
class TodoListViewController: UITableViewController {

    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    
    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    
    //MARK: TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Test
        print(itemArray[indexPath.row])
        
        // Adds flash animation to any selected cells
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Use accessory (from attributes tab) to add/ remove checkmark when cell is selected/ deselected
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            // Currently 'check marked' -> Remove checkmark
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            // Not currently 'check marked' -> Add checkmark
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
    }
    


}

