//
//  DetailViewController.swift
//  Fraværsføring EO
//
//  Created by Emil Broll on 21/12/14.
//  Copyright (c) 2014 Emil Broll. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController  {
	var keys = NSMutableArray()

	var detailItem: AnyObject? {
		didSet {
		    // Update the view.
			// self.configureView()
			print(detailItem)
			if let otherThings: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(detailItem as! String) {
				print(otherThings.description)
				keys = NSMutableArray(array: otherThings as! NSArray)
				print(keys)
				for (index, value) in keys.enumerate() {
					if (NSUserDefaults.standardUserDefaults().objectForKey(value.description) == nil) {
						keys.removeObjectIdenticalTo(value)
					}
				}
			}
		}
	}
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	//	self.navigationItem.leftBarButtonItem = self.editButtonItem()
		
		let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
		self.navigationItem.setRightBarButtonItem(addButton, animated: false)
		
		insertNewObject(NSNull)
	}

	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func editingStarted(sender: UITextField) {
		
	}
	func insertNewObject(sender: AnyObject) {
		print(keys)
		var key:Int = NSUserDefaults.standardUserDefaults().integerForKey("identifier")
		if (key == 0){
			key++;
		}
		print(key)
		print(keys)
		NSUserDefaults.standardUserDefaults().setInteger((key + 1), forKey: "identifier")

		keys.insertObject(key, atIndex: 0)
		NSUserDefaults.standardUserDefaults().setObject(keys, forKey: detailItem as! NSString as String)
		let indexPath = NSIndexPath(forRow: 0, inSection: 0)
		self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
	}
	
	@IBAction func things(sender: AnyObject) {
		print(keys)
	}
	// MARK: - Table View
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return keys.count
	}
	

	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("ReuseIdentifier", forIndexPath: indexPath) as! CustomCell
		cell.timeField.text = ""
		cell.minutterField.text = ""
		cell.navnField.text = ""
		cell.fagField.text = ""
		var key = keys.objectAtIndex(indexPath.row) as! Int
		cell.key = key
		
		//cell.textLabel!.text = object.description
		return cell
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			keys.removeObjectAtIndex(indexPath.row)
			NSUserDefaults.standardUserDefaults().setObject(keys, forKey: detailItem as! NSString as String)
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
		} else if editingStyle == .Insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		}
	}
	override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return false
	}

}

