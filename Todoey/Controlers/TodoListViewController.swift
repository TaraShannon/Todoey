//
//  ViewController.swift
//  Todoey
//
//  Created by Tara Shannon on 07/02/2018.
//  Copyright © 2018 Tara Shannon. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    
    var itemArray = [Item]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
   
        loadItems()
    }

    //Mark - Tableview Datasorce Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
       
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        if item.done == true{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
        //Mark TableviewDelegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
      
            saveItems()
    
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //Mark Add New items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Iem", style: .default) { (action) in
            //What will happen once the user clicks the add item button.
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
           self.itemArray.append(newItem)
            
         
            self.saveItems()
            
            
        }
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.placeholder = "Create new Item"
            textField = alertTextFeild
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // Mark Model Manipulation Methods
    
    func saveItems(){
        
        do{
            try context.save()
           
        }catch{
            print("Error saving context \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
     
        
        do{
        itemArray = try context.fetch(request)
        }catch{
            print("error fetching objects from context \(error)")
        }
        tableView.reloadData()


    }

    

}
// Mark - Search Bar Methods


extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
       request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        
    }
}



















