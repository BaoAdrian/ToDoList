//
//  ViewController.swift
//  ToDoList
//
//  Created by Adrian Bao on 6/27/18.
//  Copyright © 2018 Adrian Bao. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


// Inheriting UITableViewController takes care of delegate and data source responsibilities
class TodoListViewController: SwipeTableViewController {
    
    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet {
            // Everything here is triggered once selectedCategory is activiated
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
    }
    
    // Executes after viewDidLoad() allowing for navController to load, avoiding fatal error
    override func viewWillAppear(_ animated: Bool) {
        
        guard let colorHex = selectedCategory?.bgColor else {fatalError()}
        
        title = selectedCategory?.name
        
        updateNavBar(withHexCode: colorHex)

    }
    
    // Called when view is about to be removed - when returning to home screen, resets navBar to original settings
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    
    
    
    
    
    
    
    ////////////////////////////////////
    
    //MARK: NavBar Method
    
    ////////////////////////////////////
    
    
    func updateNavBar(withHexCode colorHexCode : String) {
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation Controller does not exist.")}
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
        
    }
    
    
    
    
    
    
    
    
    
    
    
    ////////////////////////////////////
    
    //MARK: TableView Datasource Methods
    
    ////////////////////////////////////
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            // Safe to unwrap selected category since it will always carry a value if triggered in this closure
            if let color = UIColor(hexString: selectedCategory!.bgColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            
            // Ternary Operator (replaces if-else statement): value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done == true ? .checkmark : .none
            
        } else {
            
            // Nil or fails
            cell.textLabel?.text = "No Items Added"
            
        }
        
        return cell
        
    }
    
    
    
    
    
    
    
    
    
    
    
    ////////////////////////////////////
    
    //MARK: TableView Delegate Methods

    ////////////////////////////////////
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    
                    // Deletes items rather than 'checkmarking'
                    // realm.delete(item)
                    
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
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
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
                
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // Method to access and load saved data - READ operation of CRUD
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item \(error)")
            }
        }
    }
    
}









////////////////////////////////

//MARK: Search Bar methods

////////////////////////////////



// Modularize program using extension of ToDoListViewController
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        // Filter todo list items
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

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



//////////////////////////////////////

//MARK: END

//////////////////////////////////////
