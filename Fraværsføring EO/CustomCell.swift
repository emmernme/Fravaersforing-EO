//
//  CustomCell.swift
//  Fraværsføring EO
//
//  Created by Emil Broll on 23/12/14.
//  Copyright (c) 2014 Emil Broll. All rights reserved.
//

import UIKit

class CustomCell : UITableViewCell, UITextFieldDelegate {
	
	@IBOutlet var fagField: UITextField!
	@IBOutlet var timeField: UITextField!
	@IBOutlet var navnField: UITextField!
	@IBOutlet var minutterField: UITextField!
	var key: Int? {
		didSet {
			if let otherThings: NSDictionary = (NSUserDefaults.standardUserDefaults().objectForKey((key! as Int).description) as? NSDictionary) {
				if (otherThings.objectForKey("fag") != nil){
					fagField.text = otherThings.objectForKey("fag") as! NSString as String
				}
				if (otherThings.objectForKey("time") != nil){
					timeField.text = (otherThings.objectForKey("time") as! NSString).stringByAppendingString(". time")
				}
				if (otherThings.objectForKey("navn") != nil){
					navnField.text = otherThings.objectForKey("navn") as! NSString as String
				}
				if (otherThings.objectForKey("minutter") != nil){
					minutterField.text = (otherThings.objectForKey("minutter") as! NSString).stringByAppendingString(" minutter")
				}
			}

		}
	}

	
	@IBAction func startedEditing(sender: AnyObject) {
		if (sender as! UITextField).isEqual(timeField){
			if (timeField.text!.rangeOfString(". time") != nil){
				timeField.text = timeField.text!.stringByReplacingOccurrencesOfString(". time", withString: "")
			}
		}
		if (sender as! UITextField).isEqual(minutterField){
			if (minutterField.text!.rangeOfString(" minutter") != nil){
				minutterField.text = minutterField.text!.stringByReplacingOccurrencesOfString(" minutter", withString: "")
			}
		}
		NSLog(sender.description)
	}
	
	@IBAction func finishedEditing(sender: AnyObject) {
		if (sender as! UITextField).isEqual(timeField){
			if (timeField.text!.rangeOfString(". time") == nil && timeField.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0){
				timeField.text = timeField.text!.stringByAppendingString(". time")
			}
		}
		if (sender as! UITextField).isEqual(minutterField){
			if (minutterField.text!.rangeOfString(" minutter") == nil && minutterField.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0){
				minutterField.text = minutterField.text!.stringByAppendingString(" minutter")
			}
		}
		let things = NSMutableDictionary()
		things["fag"] = fagField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
		things["time"] = timeField.text!.stringByReplacingOccurrencesOfString(". time", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
		things["navn"] = navnField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
		things["minutter"] = minutterField.text!.stringByReplacingOccurrencesOfString(" minutter", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
		for (key, thing) in things {
			if (thing as! NSString == "") {
				things.removeObjectForKey(key)
			}
		}
		print(things)
		print(things.count)
		if (things.count > 0){
			NSUserDefaults.standardUserDefaults().setObject(things, forKey: key!.description)
		} else {
			NSUserDefaults.standardUserDefaults().removeObjectForKey(key!.description)
		}
	}

}