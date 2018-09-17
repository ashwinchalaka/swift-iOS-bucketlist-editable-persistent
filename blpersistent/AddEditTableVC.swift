//
//  AddEditTableVC.swift
//  blpersistent
//
//  Created by Ashwin Chalaka on 9/16/18.
//  Copyright © 2018 Ashwin Chalaka. All rights reserved.
//

import UIKit

class AddEditTableVC: UITableViewController {
    
    weak var delegate: AddEditTableVCDelegate?
    @IBOutlet weak var newTableItem: UITextField!
    var selectedItem: String?
    var indexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newTableItem.text = selectedItem
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        delegate?.cancelButtonPressed(self, didPressCancelButton: sender)
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        let text = newTableItem.text
        delegate?.addItemViewController(self, didFinishAddingItem: text!, at: indexPath)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
