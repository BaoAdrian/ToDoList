//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Adrian Bao on 7/7/18.
//  Copyright © 2018 Adrian Bao. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    
    
    
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
        
    }
    
    
    
    
    
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        // Grab corresponding category
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    
    
    
    
    
    
    //MARK: - Data Manipulation methods
    
    // Methods that saves and updates/reloads the current status of each item in list (i.e. title and done) - UPDATE operation of CRUD
    func saveCategories() {
        
        
        // Commit and save changes made to data from context into the Database
        do {
            try context.save()
        } catch {
            print("Error saving category, \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    // Method to access and load saved data - READ operation of CRUD
    func loadCategories() {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            // fetch results from database and save into array
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching categories \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    
    
    
    
    
    //MARK: - Add new Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        /* What happens when user clicks add button */
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // Add text to array
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
            
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



//MARK: - END
