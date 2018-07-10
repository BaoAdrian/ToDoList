//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Adrian Bao on 7/7/18.
//  Copyright © 2018 Adrian Bao. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    
    
    
    //////////////////////////////////////
    
    //MARK: - TableView Datasource Methods
    
    //////////////////////////////////////
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Nil Coalescing Operator
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
        
    }
    
    
    
    
    
    
    //////////////////////////////////////
    
    //MARK: - TableView Delegate Methods
    
    //////////////////////////////////////
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        // Grab corresponding category
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
    
    
    
    //////////////////////////////////////
    
    //MARK: - Data Manipulation methods
    
    //////////////////////////////////////
    
    // Methods that saves and updates/reloads the current status of each item in list (i.e. title and done) - UPDATE operation of CRUD
    func save(category: Category) {
        
        // Commit and save changes made to data from context into the Database
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    // Method to access and load saved data - READ operation of CRUD
    func loadCategories() {
        
        // This retrieves all items within realm database that are of specified category objects
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    
    
    
    
    //////////////////////////////////////
    
    //MARK: - Add new Categories
    
    //////////////////////////////////////
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        /* What happens when user clicks add button */
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // Add text to array
            let newCategory = Category()
            newCategory.name = textField.text!
            
            /* Auto updates, no need to append/add to list */
            
            self.save(category: newCategory)
            
            // print("Success, Add Item Pressed")
            // print(textField.text)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}

//////////////////////////////////////

//MARK: - END

//////////////////////////////////////
