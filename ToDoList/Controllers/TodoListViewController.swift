//
//  ViewController.swift
//  ToDoList
//
//  Created by Adrian Bao on 6/27/18.
//  Copyright © 2018 Adrian Bao. All rights reserved.
//

import UIKit
import CoreData



// Inheriting UITableViewController takes care of delegate and data source responsibilities
class TodoListViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            // Everything here is triggered once selectedCategory is activiated
            loadItems()
        }
    }
    
    // CREATE operation of CRUD
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // An interface to the user’s defaults database, where you store key-value pairs persistently across launches of your app
    // let defaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Prints data path where data is being stored
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // Data path used to test current status before/after modifications
        // print(dataFilePath)
        
        
        loadItems()
        
        
    }
    
    
    

    
    
    ////////////////////////////////////
    
    //MARK: TableView Datasource Methods
    
    ////////////////////////////////////
    
    
    
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
    
    
    
    
    
    
    ////////////////////////////////////
    
    //MARK: TableView Delegate Methods

    ////////////////////////////////////
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Test
        // print(itemArray[indexPath.row])
        
        
        // Deleting items from database - DELETE operation of CRUD
        // context.delete(itemArray[indexPath.row])
        // itemArray.remove(at: indexPath.row)
        
        
        // Check to see if items have been 'checked' or DONE, if not, implements the opposite of current status
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        // Adds flash animation to any selected cells
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    
    
    ////////////////////////////////
    
    //MARK: Add new items
    
    ////////////////////////////////
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        /* What happens when user clicks add button */
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // Add text to array
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            // print("Success, Add Item Pressed")
            // print(textField.text)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // Methods that saves and updates/reloads the current status of each item in list (i.e. title and done) - UPDATE operation of CRUD
    func saveItems() {
        
        
        // Commit and save changes made to data from context into the Database
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    // Method to access and load saved data - READ operation of CRUD
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

        // All items we retrieve must have the NAME attribute to match the parentCategory
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        // Optional binding to ensure that if no predicate is passed, still completes loading of items
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            // fetch results from database and save into array
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
}




////////////////////////////////

//MARK: Search Bar methods

////////////////////////////////



// Modularize program using extension of ToDoListViewController
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // Filter for query - search database for any title that contains param (searchBar.text)
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // [cd] removes case & diacretic sensitivity
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            // Triggered when user clears search bar after quering item
            loadItems()
            
            // Removes Keyboard from the screen as search bar is no longer being edited
            DispatchQueue.main.async { // Requests main thread to process UI Request
                searchBar.resignFirstResponder()
            }
            
        }
        
    }
    
    
    
}





















//MARK: END


