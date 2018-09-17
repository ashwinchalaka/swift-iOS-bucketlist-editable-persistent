//
//  HomeTableVC.swift
//  blpersistent
//
//  Created by Ashwin Chalaka on 9/16/18.
//  Copyright © 2018 Ashwin Chalaka. All rights reserved.
//

import UIKit
import CoreData // STEP #1

protocol AddEditTableVCDelegate: class {
    func cancelButtonPressed(_ controller: AddEditTableVC, didPressCancelButton button: UIBarButtonItem)
    func addItemViewController(_ controller: AddEditTableVC, didFinishAddingItem item: String, at indexPath: NSIndexPath?)
}

class HomeTableVC: UITableViewController, AddEditTableVCDelegate {
    
    // STEP #4: change hard corded items array to a BucketListItem object
    // Define items that go into our main table
    var items = [BucketListItem]()
    //"Go to the moon", "Swim in the Amazon", "Ride a motorcycle in Tokyo", "Become a professional iOS Developer", "Finish this section"
    
    // STEP #2
    // This is the object that starts off as a kind of "scratch pad", we can add, edit, and delete items with this object then we can save those additions/changes to the database.
    let managedObjectContext = (UIApplication.shared.delegate as!  AppDelegate).persistentContainer.viewContext
    
    // STEP #3
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BucketListItem")
        do {
            let result = try managedObjectContext.fetch(request)
            items = result as! [BucketListItem]
        }
        catch {
            print("error with fetchAllItems request.")
        }
    }
    
    // Execute these commands when the view controller loads for the first time
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllItems() // STEP #10
    }
    
    // Dynamic Table setup...
    // (1) - define the number of table cells in a section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    // (2) - define the values displayed in each table cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BLCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].text! // STEP #5: include ".text!" at the end
        return cell
    }
    
    // Conform to AddEditTableVCDelegate protocol...
    // (1) - What happens to this VC when the "Cancel" button is pressed on the other VC
    func cancelButtonPressed(_ controller: AddEditTableVC, didPressCancelButton button: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // (2) - What happens to this VC when the "Save" button is pressed on the other VC
    func addItemViewController(_ controller: AddEditTableVC, didFinishAddingItem text: String, at indexPath: NSIndexPath?) {
        if let path = indexPath {
            // STEP #7 -- for updating an item
            let item = items[path.row]
            item.text = text           // STEP #7
        }
        else {
            // STEP #8 -- for adding an item
            let item = NSEntityDescription.insertNewObject(forEntityName: "BucketListItem", into: managedObjectContext) as! BucketListItem
            item.text = text           // STEP #8
            items.append(item)
        }
        // STEP #9 -- for saving the addition/change
        do {
            try managedObjectContext.save()
        }
        catch {
            print("error: managed object did not save")
        }
        
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ChangeTableSegue", sender: sender)
    }
    
    // Will listen for anytime someone clicks an existing row's "i" (info) button in the table
    // Then this will go through the prepare function below and set up the next VC based on the particular table row that was picked
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "ChangeTableSegue", sender: indexPath)
    }
    
    // Enabling functionality "swipe to delete"
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // STEP #11
        let item = items[indexPath.row]
        managedObjectContext.delete(item) // STEP #11
        
        // STEP #12 -- for saving the deletion
        do {
            try managedObjectContext.save()
        }
        catch {
            print("error: managed object did not save")
        }
        
        items.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    // Required function to prepare for all segues from this controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender is UIBarButtonItem {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! AddEditTableVC
            controller.delegate = self
        }
        else {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! AddEditTableVC
            controller.delegate = self
            
            // (a) - save the index information relating the row that is selected
            // (b) - save the contents of the selected row in a variable inside the destination VC
            // (c) - save the contents of the editted row in the correct row index
            let indexPath = sender as! NSIndexPath // (a)
            let item = items[indexPath.row]        // (b)
            controller.selectedItem = item.text!   // STEP #6: include ".text!" // (b)
            controller.indexPath = indexPath       // (c)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
