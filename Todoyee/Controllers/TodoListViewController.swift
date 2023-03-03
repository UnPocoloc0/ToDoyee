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
        
        
        // Remove item from permanent storage
        // Order of these methods are important, otherwise index out of range
        context.delete(itemArray[indexPath.row])
        
        // Update itemArray, does nothing to coreData
        //Remove item from array
        itemArray.remove(at: indexPath.row)
        
     
        //Short way using opposite, true becomes false and vice versa: Togglin' on & off
        // This updates the current row. Row is NSMangedobject, tap it's done property
        // Use checkmark or delete row, which is better user experience?
        
    // itemArray[indexPath.row].done = !itemArray[indexPath.row].done
       // Deleting is not enough, must always save the current status
        
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
        // Forces tableView to call datasoucre again, show the latest data
        self.tableView.reloadData()
    }
    
    // Pulls back everything that is in the persistent container
    // Request is the parameter, return is array of items
    // Use internal name inside this block of code
    
    // Use the default value Item.fetchRequest. LoadItems has a default request.
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        // Must specify the datatype here
        
        do {
            // Save the result to itemArray
        itemArray = try context.fetch(request)
            
        } catch {
            print("Error fetching data from context \(error)")
        }
        

}
   
    
}

// MARK: Search bar methods
// Modularize the code, easier to navigate and debug. Otherwise base class grows gigantic.
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // When user taps searchbar, function is fired inside the braces
        let request: NSFetchRequest<Item> = Item.fetchRequest()
       
        // NSPredicate is how data should be filtered. cd means case and diacritic insensitive
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        // Title should contain what is inthe search bar, ascending alphabetical order
        //let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        // Needs the square brackets on the RH side to match code below
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // Plural on the other side, singular on the other
//        request.sortDescriptors = [sortDescriptor]
        
        // Use the external parameter when calling the function. Code is almost almost plain english
        
        loadItems(with: request)
//        do {
//            // Save the result to itemArray
//            itemArray = try context.fetch(request)
//
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
        
//        tableView.reloadData()
//        // Prints what the user has entered, check it along the way
//        print(searchBar.text!)
    }
    // Before refactoring, check if the current code works
    // Triggers the delegate method when text inside searchbar has changed
    // Every letter triggers this method, also clear field triggers this
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Only when there's text in the field if statement triggers
        if searchBar.text?.count == 0 {
            loadItems()
            
            
            DispatchQueue.main.async {
                // Hide the keyboard and go to original state
                searchBar.resignFirstResponder()
            }
           
        }
    }
}
