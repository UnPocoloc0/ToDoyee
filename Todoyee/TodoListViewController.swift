//
//  ViewController.swift
//  Todoyee
//
//  Created by Juuso Loikkanen on 22.1.2023.
//  Copyright © 2023 Simo Loikkanen. All rights reserved.
//

import UIKit
// Get lot of stuff for free by subclassing UITableViewController, change the superclass here
class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike!", "Buy Eggos!", "Destroy Demogorgon!"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
            }
    }

    // MARK: - TableView Datasource Methods
    
   // This creates 3 cells in tableview, start writing tableview and use autofill
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        // Populate cell with text at current row
        cell.textLabel?.text = itemArray[indexPath.row]
        // Return the cell as a row
        return cell
    }
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Access to individual items with indexPath.row
         print(itemArray[indexPath.row])
        
       // Condition to add and remove checkmark
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
             tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
      // This highlights the row briefly
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
       
    }
    // MARK: Add New Item with UIAlertController
    
    
    @IBAction func AddButttonPressed(_ sender: UIBarButtonItem) {
        
        // Create a local variable
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the "add new item" button on UIalert
            self.itemArray.append(textField.text!)
            // This magic method adds new item to list
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            // Extend the scope of alertTextField to whole AddButtonPressed
            textField = alertTextField
           
          
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}

