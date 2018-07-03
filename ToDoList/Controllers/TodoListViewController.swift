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
    
    
    // Replaced hardcoded array with new Data Model -> Item Objects
    // var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    var itemArray = [Item]()
    
    
    // An interface to the user’s defaults database, where you store key-value pairs persistently across launches of your app
    let defaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
       
        
        
        
        // Checks if items are stored using the defaults is correct, loads the View with current data from defaults
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {

            itemArray = items

        }
        
    }
    
    
    

    
    
    
    
    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // Set constant to simplify code
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Ternary Operator (replaces if-else statement): value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
        
    }
    
    
    
    
    
    
    
    
    //MARK: TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Test
        // print(itemArray[indexPath.row])
        
        
        // Check to see if items have been 'checked' or DONE, if not, implements the opposite of current status
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Updates tableView with respective checkmarks
        tableView.reloadData()
        
        // Adds flash animation to any selected cells
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    //MARK: Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            /* What happens when user clicks add button */
            
            // Add text to array
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            // Save updated itemArray to UserDefaults
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            // Once item is added, tableView is reloaded to include
            self.tableView.reloadData()
            
            // print("Success, Add Item Pressed")
            // print(textField.text)
        }
        
        // Creates mini pop up window (alert) to request user to enter a new item
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    

}

