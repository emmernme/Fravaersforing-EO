//
//  Veileder.swift
//  EO Hedmark
//
//  Created by Emil Broll on 28/12/14.
//  Copyright (c) 2014 Emil Broll. All rights reserved.
//

import UIKit

class Veileder : UIViewController, UIWebViewDelegate {

	@IBOutlet var webView: UIWebView!

	func totallyDismiss(){
		NSUserDefaults.standardUserDefaults().setBool(true, forKey: "terms")
		navigationController?.popViewControllerAnimated(true)
	}
	override func viewWillAppear(animated: Bool) {
		self.navigationController?.setNavigationBarHidden(false, animated:true)
	}


	func dismiss(){
		if (NSUserDefaults.standardUserDefaults().boolForKey("terms")){
			totallyDismiss()
			return
		}

		let alert = UIAlertController(title: "Lest og forstått veilederen?", message: "Veilederen må leses og følges for at fraværsføringen skal gjennomføres på en forsvarlig måte. Ønsker du å lese denne en gang til?", preferredStyle: UIAlertControllerStyle.Alert)
		let again = UIAlertAction(title: "Jeg vil lese den en gang til", style: UIAlertActionStyle.Default, handler: nil)
		let finished = UIAlertAction(title: "Jeg har lest og vil følge veilederen", style: UIAlertActionStyle.Cancel, handler: { (alert) -> Void in
			self.totallyDismiss()
		})
		alert.addAction(finished)
		alert.addAction(again)
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	override func viewDidLoad() -> Void {
		self.title = "Les veilederen"
		let accept = UIBarButtonItem(title: "OK", style: .Done, target: self, action: "dismiss")
		self.navigationItem.rightBarButtonItem = accept
		self.navigationItem.setHidesBackButton(true, animated: false)
		self.navigationController?.navigationBar.translucent = false
		self.navigationController?.navigationBarHidden = false

		
		let path = NSBundle.mainBundle().URLForResource("Veileder", withExtension: "pdf")
		print(path)
		webView.loadRequest(NSURLRequest(URL: path!))
	}
	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		if (navigationType == UIWebViewNavigationType.LinkClicked){
			UIApplication.sharedApplication().openURL(request.URL!)
			return false
		}
		return true
	}
}
