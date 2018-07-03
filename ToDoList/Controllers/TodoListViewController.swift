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
    
    var itemArray = [Item]()
    
    // Create fi	le path to documents folder
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // An interface to the user’s defaults database, where you store key-value pairs persistently across launches of your app
    // let defaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        // Data path used to test current status before/after modifications
        // print(dataFilePath)
        
        
        
        
        loadItems()
        
        
        
        
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
        
        saveItems()
        
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
            
            self.saveItems()
            
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
    
    
    // Methods that saves and updates/reloads the current status of each item in list (i.e. title and done)
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            // Error
            print("Error encoding item array, \(error)")
        }
        
        // Once item is added, tableView is reloaded to include
        tableView.reloadData()
        
    }
    
    
    // Method to access and load saved data
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                // Error
                print("Error decoding item array, \(error)")
            }
            
        }
        
    }
    
    

}

