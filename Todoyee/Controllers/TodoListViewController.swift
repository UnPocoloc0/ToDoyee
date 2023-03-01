//
//  ViewController.swift
//  Todoyee
//
//  Created by Juuso Loikkanen on 22.1.2023.
//  Copyright © 2023 Simo Loikkanen. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        
        loadItems()

        // Value is custom item object
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
    }

    // MARK: - TableView Datasource Methods, what shall display, how many rows
    
   // This creates 3 cells in tableview, start writing tableview and use autofill
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        // Populate cell with text at current row
        cell.textLabel?.text = item.title
        // Return the cell as a row
        
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        // One line expression, doesn't work for some reason
//        cell.accessoryType = item.done ? .checkmark : .none
       
        
         if item.done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Access to individual items with indexPath.row
         print(itemArray[indexPath.row])
        
        //Short way using opposite, true becomes false and vice versa:
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        // Long way:
//        // Toggling on off
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        
        

      // This highlights the row briefly
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//
//    }
    // MARK: Add New Item with UIAlertController
    
    
    @IBAction func AddButttonPressed(_ sender: UIBarButtonItem) {
        
        // Create a local variable
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the "add new item" button on UIalert
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            // This magic method adds new item to list
             self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            // Extend the scope of alertTextField to whole AddButtonPressed
            textField = alertTextField
           
          
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Model manipulation methods
    
    func saveItems() {
        
        // Using do-catch blocks
        do{
          try context.save()
        } catch {
           print("Error saving context \(error)")
            
        }
        // Forces tableView to call datasoucre again
        self.tableView.reloadData()
    }
    
    // Pulls back everything that is in the persistent container
    func loadItems() {
        // Must specify the datatype here
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            // Save the result to itemArray
        itemArray = try context.fetch(request)
            
        } catch {
            print("Error fetching data from context \(error)")
        }
        

}
}
