//
//  SplashViewController.swift
//  Fraværsføring
//
//  Created by Emil Broll on 28/12/14.
//  Copyright (c) 2014 Emil Broll. All rights reserved.
//

import UIKit
import QuartzCore

class SplashViewController : UIViewController {
	
	@IBOutlet var bilde: UIImageView!
	@IBOutlet var veilederButton: UIButton!
	@IBOutlet var veilederIcon: UIButton!
	@IBOutlet var skjemaButton: UIButton!
	@IBOutlet var skjemaIcon: UIButton!
	@IBAction func veilederPressed(sender: AnyObject) {
		let colorAnimation = CABasicAnimation(keyPath: "borderColor")
		colorAnimation.toValue = UIColor.whiteColor().colorWithAlphaComponent(0.1).CGColor
		colorAnimation.removedOnCompletion = false
		colorAnimation.fillMode = kCAFillModeForwards
		colorAnimation.speed = 100
		colorAnimation.duration = 0
		veilederIcon.layer.addAnimation(colorAnimation, forKey: nil)

		veilederButton.highlighted = true
		veilederIcon.highlighted = true
	}
	@IBAction func veilederCancelled(sender: AnyObject) {
		let colorAnimation = CABasicAnimation(keyPath: "borderColor")
		colorAnimation.toValue = UIColor.whiteColor().CGColor
		colorAnimation.removedOnCompletion = false
		colorAnimation.fillMode = kCAFillModeForwards
		colorAnimation.duration = 0.175
		veilederIcon.layer.addAnimation(colorAnimation, forKey: nil)

		veilederButton.highlighted = false
		veilederIcon.highlighted = false
	}
	@IBAction func pressVeileder(sender: AnyObject) {
		let colorAnimation = CABasicAnimation(keyPath: "borderColor")
		colorAnimation.toValue = UIColor.whiteColor().CGColor
		colorAnimation.removedOnCompletion = false
		colorAnimation.fillMode = kCAFillModeForwards
		colorAnimation.duration = 0.175
		veilederIcon.layer.addAnimation(colorAnimation, forKey: nil)

		veilederButton.highlighted = false
		veilederIcon.highlighted = false
		if (sender as? UIButton != veilederButton){
		self.performSegueWithIdentifier("visVeileder", sender: nil)
		}
	}
	@IBAction func skjemaPressed(sender: AnyObject) {
		let colorAnimation = CABasicAnimation(keyPath: "borderColor")
		colorAnimation.toValue = UIColor.whiteColor().colorWithAlphaComponent(0.1).CGColor
		colorAnimation.removedOnCompletion = false
		colorAnimation.fillMode = kCAFillModeForwards
		colorAnimation.duration = 0
		colorAnimation.speed = 100
		skjemaIcon.layer.addAnimation(colorAnimation, forKey: nil)

		skjemaButton.highlighted = true
		skjemaIcon.highlighted = true
	}
	@IBAction func skjemaCancelled(sender: AnyObject) {
		let colorAnimation = CABasicAnimation(keyPath: "borderColor")
		colorAnimation.toValue = UIColor.whiteColor().CGColor
		colorAnimation.removedOnCompletion = false
		colorAnimation.fillMode = kCAFillModeForwards
		colorAnimation.duration = 0.175
		skjemaIcon.layer.addAnimation(colorAnimation, forKey: nil)

		skjemaButton.highlighted = false
		skjemaIcon.highlighted = false
	}
	@IBAction func pressSkjema(sender: AnyObject) {
		let colorAnimation = CABasicAnimation(keyPath: "borderColor")
		colorAnimation.toValue = UIColor.whiteColor().CGColor
		colorAnimation.removedOnCompletion = false
		colorAnimation.fillMode = kCAFillModeForwards
		colorAnimation.duration = 0.175
		skjemaIcon.layer.addAnimation(colorAnimation, forKey: nil)

		skjemaButton.highlighted = false
		skjemaIcon.highlighted = false
		if (sender as? UIButton != skjemaButton){
			self.performSegueWithIdentifier("visRoot", sender: nil)
		}
	}
	
	override func viewDidLoad() {
		veilederIcon.layer.borderWidth = 1.8
		veilederIcon.layer.borderColor = UIColor.whiteColor().CGColor
		veilederIcon.layer.cornerRadius = veilederIcon.frame.size.height / 2
		skjemaIcon.layer.borderWidth = 2.0
		skjemaIcon.layer.borderColor = UIColor.whiteColor().CGColor
		skjemaIcon.layer.cornerRadius = skjemaIcon.frame.size.height / 2

		
		navigationController?.setNavigationBarHidden(true, animated:false)
		self.title = ""
		
		if (!NSUserDefaults.standardUserDefaults().boolForKey("terms")){
			self.performSegueWithIdentifier("visVeileder", sender: nil)
		}
	}
	@IBAction func hey(sender: AnyObject) {
		print("Hey")
	}
	override func viewWillAppear(animated: Bool) {
		self.navigationController?.setNavigationBarHidden(true, animated:true)
	}
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	@IBAction func openSafari(sender: AnyObject) {
		UIApplication.sharedApplication().openURL(NSURL(string: "http://elev.no/Hva-er-EO")!)
	}
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		print(segue.identifier)
		if (segue.identifier == "visVeileder"){
			
		}
		if segue.identifier == "showDetail" {
			print(segue)
			let a = segue.sourceViewController as! MasterViewController
			if let indexPath = a.tableView.indexPathForSelectedRow {
				let cell = sender as! UITableViewCell
				var tag = cell.tag.description
				(segue.destinationViewController as! DetailViewController).detailItem = tag
				print(cell.tag.description)
				(segue.destinationViewController as! DetailViewController).title = cell.textLabel?.text
				
			}
		}
		if segue.identifier == "showShare" {
			print(segue)

			let a = segue.sourceViewController as! MasterViewController
			let destination = (segue.destinationViewController as! ShareViewController)
			
			//destination.currentWeek = a.weeks!.objectForKey(a.weekRows!.objectAtIndex(0)) as String
		}
		
	}
}
