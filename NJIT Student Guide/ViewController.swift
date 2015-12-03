//
//  ViewController.swift
//  todoapp
//
//  Created by Arif Mukhthar on 10/20/15.
//  Copyright © 2015 arif. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var itemList:Array<ToDoModel> = []
    var todo: toDoPersist!
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func addItem(sender: UIButton) {
        let newItem = textField.text
        todo.insertIntoDataStore(newItem, tick: "No")
        textField.resignFirstResponder()
        textField.text = ""
        loadData()
        tableView.reloadData()
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
        }

    func loadData(){
        self.todo = toDoPersist.sharedInstance
        self.itemList = todo.fetchFromDataStore()
        tableView.dataSource = self
        tableView.delegate = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    internal func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
{
    return self.itemList.count
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let item: ToDoModel!
        item = itemList[indexPath.row]
        cell.textLabel?.text = item.items
        cell.textLabel?.textColor = UIColor.redColor()
        if(item.tick == "yes"){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        return cell
        
 }
    internal override func viewWillAppear(animated: Bool) {
      
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRow = tableView.cellForRowAtIndexPath(indexPath)!
        if selectedRow.accessoryType == UITableViewCellAccessoryType.None
        {
            selectedRow.accessoryType = UITableViewCellAccessoryType.Checkmark
            selectedRow.tintColor = UIColor.greenColor()
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.managedObjectContext
            context.deleteObject(itemList[indexPath.row] as NSManagedObject)
            let item = itemList[indexPath.row]
            todo.insertIntoDataStore(item.items, tick: "yes")
            
            
            
        }
        else if selectedRow.accessoryType == UITableViewCellAccessoryType.Checkmark
        {
            selectedRow.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            // remove the deleted item from the model
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.managedObjectContext
            context.deleteObject(itemList[indexPath.row] as NSManagedObject)
            itemList.removeAtIndex(indexPath.row)
            do {
             try context.save()
                
            } catch {
                
            }
            
            //tableView.reloadData()
            // remove the deleted item from the `UITableView`
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            return
        
        
        
    }
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
            
        }
    }
    
   
}

