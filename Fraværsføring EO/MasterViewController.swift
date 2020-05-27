//
//  MasterViewController.swift
//  Fraværsføring EO
//
//  Created by Emil Broll on 21/12/14.
//  Copyright (c) 2014 Emil Broll. All rights reserved.
//

import UIKit

class DayCell : UITableViewCell {
	var key:NSString?
}
class MasterViewController: UITableViewController {

	var objects = NSMutableArray()
	var keys = NSMutableArray()
	var currentWeek:Int?
	var dateComponents = NSDateComponents()
	let calendar = NSCalendar.currentCalendar()
	var today: Int?
	var weekRows: NSArray?
	var weeks: NSDictionary?
	let this = NSDate()//.dateByAddingTimeInterval(-2*24*60*60)
	

	override func awakeFromNib() {
		super.awakeFromNib()
	}
	@IBAction func showVeileder(){
		veileder(true)
	}
	func veileder(animated:Bool) {
		let veileder = Veileder(nibName: "Veileder", bundle: nil)
		navigationController?.pushViewController(veileder, animated: animated)
	}
	override func viewWillAppear(animated: Bool) {
		self.navigationController?.setNavigationBarHidden(false, animated:true)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = ""
		self.navigationController?.navigationBarHidden = false

		calendar.firstWeekday = 2
		calendar.locale = NSLocale(localeIdentifier: "nb_NO")
		currentWeek = calendar.components(NSCalendarUnit.WeekOfYear, fromDate: this).weekOfYear as Int
		let year = calendar.components(NSCalendarUnit.YearForWeekOfYear, fromDate: this).yearForWeekOfYear as Int
		today = calendar.components(.Weekday, fromDate: this).weekday
		NSLog("Currentweek: %d, today: %d", currentWeek!, today!)
		
		let rows = NSMutableArray()
		let someWeeks = NSMutableDictionary()
		rows.addObject(0)
		someWeeks.setObject("\(currentWeek!) \(year)", forKey: 0)
		var daysLeftInWeek = today! - 1
		daysLeftInWeek += (daysLeftInWeek == 0) ? 7 : 0
		
		for (var days = daysLeftInWeek; days < 365; days += 7) {
			rows.addObject(days + rows.count)
			dateComponents.weekOfYear = -(rows.count - 1)
			let date: NSDate = calendar.dateByAddingComponents(dateComponents, toDate: this, options: [])!
			let newWeek = calendar.components(NSCalendarUnit.WeekOfYear, fromDate: date).weekOfYear as Int
			let newYear = calendar.components(NSCalendarUnit.YearForWeekOfYear, fromDate: date).yearForWeekOfYear as Int
			someWeeks.setObject("\(newWeek) \(newYear)", forKey: (daysLeftInWeek + rows.count - 1))
		}
		dateComponents = NSDateComponents()
		print(rows)
		print(someWeeks)
		self.weekRows = rows
		self.weeks = someWeeks
		
		if (!NSUserDefaults.standardUserDefaults().boolForKey("master")){
			let alert = UIAlertController(title: "Instruksjoner", message: "Legg til timer uten undervisning ved å trykke på ukedagene, og se hele fraværsskjemaet ved å trykke på knappen øverst til høyre.", preferredStyle: UIAlertControllerStyle.Alert)
			let finished = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
			alert.addAction(finished)
			self.presentViewController(alert, animated: true, completion: nil)
			NSUserDefaults.standardUserDefaults().setBool(true, forKey: "master")
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Segues

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		print(segue.identifier)

		if segue.identifier == "showDetail" {
			print(segue)
		    if let indexPath = self.tableView.indexPathForSelectedRow {
				let cell = sender as! DayCell
				var tag = cell.tag.description
				(segue.destinationViewController as! DetailViewController).detailItem = cell.key
				print(cell.tag.description)
				(segue.destinationViewController as! DetailViewController).title = cell.textLabel?.text

		    }
		}
		if segue.identifier == "showShare" {
			let destination = (segue.destinationViewController as! ShareViewController)
			destination.updateWebView()
			//destination.currentWeek = weeks!.objectForKey(weekRows!.objectAtIndex(0)) as String
		}
	
	}

	// MARK: - Table View

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if (weekRows!.containsObject(indexPath.row)){
			return 26
		}

		var i:Int = indexPath.row
		var less: Bool = true
		while (less){
			if (weekRows!.containsObject(i)){
				less = false
				break
			}
			i++;
		}
		let preceding = weekRows!.indexOfObject(i)
		dateComponents.day = -(Int(indexPath.row) - preceding)
		let date: NSDate = calendar.dateByAddingComponents(dateComponents, toDate: NSDate(), options: [])!
		let weekday = calendar.components(NSCalendarUnit.Weekday, fromDate: date).weekday
		if (weekday == 1 || weekday == 7){
			return 0
		} else {
			return 44
		}
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 365
	}
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

		if ((self.weekRows!.containsObject(indexPath.row))){
			let cell = tableView.dequeueReusableCellWithIdentifier("Uke", forIndexPath: indexPath) as UITableViewCell
			print(weeks!.objectForKey(indexPath.row))
			let week: NSString = weeks!.objectForKey(indexPath.row) as! NSString
			cell.textLabel!.text = "Uke \(week)"
			cell.selectionStyle = UITableViewCellSelectionStyle.None
			return cell
		}
		var i:Int = indexPath.row
		var less: Bool = true
		while (less){
			if (weekRows!.containsObject(i)){
				less = false
				break
			}
			i++
		}
		let preceding = weekRows!.indexOfObject(i)
		dateComponents.day = -(Int(indexPath.row) - preceding)
		let date: NSDate = calendar.dateByAddingComponents(dateComponents, toDate: this, options: [])!
		
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! DayCell
		let weekday = calendar.components(NSCalendarUnit.Weekday, fromDate: date).weekday
		if (weekday == 1 || weekday == 7){
			cell.hidden = true
		}
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.locale = NSLocale(localeIdentifier: "nb")
		dateFormatter.dateFormat = "ddMMyy" // superset of OP's format
		let key = dateFormatter.stringFromDate(date)
		print(key)
		dateFormatter.dateFormat = "EEEE dd. MMMM" // superset of OP's format
		var str = dateFormatter.stringFromDate(date)
		str = str[str.startIndex...str.startIndex].uppercaseString + str[str.startIndex.advancedBy(1)..<str.endIndex]

		
		
		cell.textLabel!.text = str
		cell.tag = Int(key)!
		cell.key = key
		return cell
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return false
	}
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}

