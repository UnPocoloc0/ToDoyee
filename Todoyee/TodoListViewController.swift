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
    
    let itemArray = ["Find Mike!", "Buy Eggos!", "Destroy Demogorgon!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    
    
}

