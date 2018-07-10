//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Adrian Bao on 7/7/18.
//  Copyright © 2018 Adrian Bao. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
        
    }
    
    
    
    
    //////////////////////////////////////
    
    //MARK: - TableView Datasource Methods
    
    //////////////////////////////////////
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Nil Coalescing Operator
        return categories?.count ?? 1
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Inherits cell from superclass - created as SwipeTableViewCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.bgColor) else {fatalError()}
            
            // If category has no color, defaults to top nav bar color
            cell.backgroundColor = categoryColor
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
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
    
    //MARK: - Delete Data from Swipe
    
    //////////////////////////////////////
    
    // Overrides func in super class to update Realm Data for deleting cells (categories & cells)
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
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
            newCategory.bgColor = UIColor.randomFlat.hexValue()
            
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
