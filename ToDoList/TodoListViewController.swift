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

    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    
    // An interface to the user’s defaults database, where you store key-value pairs persistently across launches of your app
    let defaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Checks if items are stored using the defaults is correct, loads the View with current data from defaults
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
            
            itemArray = items
            
        }
        
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
    
    
    //MARK: Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            /* What happens when user clicks add button */
            
            // Add text to array
            self.itemArray.append(textField.text!)
            
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

