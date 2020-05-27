//
//  ShareViewController.swift
//  Fraværsføring EO
//
//  Created by Emil Broll on 25/12/14.
//  Copyright (c) 2014 Emil Broll. All rights reserved.
//

import UIKit
import MessageUI

class BNHtmlPdfKitPageRenderer : UIPrintPageRenderer {
	var topAndBottomMarginSize:CGFloat?
	var leftAndRightMarginSize:CGFloat?
	
	func BNpaperRect() -> CGRect {
		return UIGraphicsGetPDFContextBounds()
	}
	func BNprintableRect() -> CGRect {
		return CGRectInset(self.paperRect, self.leftAndRightMarginSize!, self.topAndBottomMarginSize!);
	}
}

class ShareViewController : UIViewController, UIWebViewDelegate, MFMailComposeViewControllerDelegate {
	
	@IBOutlet var cool: UIWebView!
	@IBOutlet var prevButton: UIBarButtonItem!
	@IBOutlet var nextButton: UIBarButtonItem!
	var data:NSArray?
	//var monday:NSDate?
	//var currentMonday:NSDate?
	let composer = MFMailComposeViewController()
	/*var currentWeek: AnyObject? {
		didSet {
			//self.week = currentWeek as NSString
			//println(week)
		}
	}*/
	func updateWebView (){
		let cal = NSCalendar.currentCalendar()
		cal.firstWeekday = 2
		/*var parts = (week as NSString).componentsSeparatedByString(" ")
		println(week)
		let w = parts[0].integerValue
		let y = parts[1].integerValue
		monday = cal.dateWithEra(1, yearForWeekOfYear: y, weekOfYear: w, weekday: 2, hour: 0, minute: 0, second: 0, nanosecond: 0)!
		if (currentMonday == nil){
			currentMonday = monday!
		}
		let sunday:NSDate = cal.dateWithEra(1, yearForWeekOfYear: y, weekOfYear: w, weekday: 1, hour: 0, minute: 0, second: 0, nanosecond: 0)!
		*/
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "ddMMyy"
		let niceFormatter = NSDateFormatter()
		niceFormatter.dateFormat = "EEEE dd. MMMM yyyy"
		
		var objects = NSMutableArray()
		var day = NSDate()
		let end = day.dateByAddingTimeInterval(-356*24*60*60)
		print("Day: \(day)")
		while (day != end){
			//// Won't run on Sunday
			let dayString = dateFormatter.stringFromDate(day)
			print(dayString)
			
			if let this: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(dayString) {
				var keys = this as! NSArray
				for i in keys {
					print(i)
					if let hello: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(i.description) {
						let cool = NSMutableDictionary(dictionary: hello as! NSDictionary)
						cool.setObject(niceFormatter.stringFromDate(day), forKey: "dato")
						objects.addObject(cool)
					}
				}
			}
			day = day.dateByAddingTimeInterval(-24*60*60)
		}
		print("End: \(end)")
		print(objects)
		self.data = objects
	}
	/*var week: AnyObject? {
		didSet {
			updateWebView()
		}
	}
	@IBAction func prevWeek(sender: AnyObject) {
		let cal = NSCalendar.currentCalendar()
		cal.firstWeekday = 2

		let components = NSDateComponents()
		components.weekOfYear = -1
		let date: NSDate = cal.dateByAddingComponents(components, toDate: monday!, options: nil)!
		println(monday!)
		println(date)
		let newWeek = cal.components(NSCalendarUnit.WeekOfYearCalendarUnit, fromDate: date).weekOfYear as Int
		let newYear = cal.components(NSCalendarUnit.YearForWeekOfYearCalendarUnit, fromDate: date).yearForWeekOfYear as Int
		
		nextButton.enabled = true

		self.week = "\(newWeek) \(newYear)"
		updateWebView()
		self.title = "Uke \(self.week!)"
		let url:NSURL = NSBundle.mainBundle().URLForResource("Export", withExtension: "html")!
		cool.loadRequest(NSURLRequest(URL: url))
	}
	@IBAction func nextWeek(sender: AnyObject) {
		let cal = NSCalendar.currentCalendar()
		cal.firstWeekday = 2

		let components = NSDateComponents()
		components.weekOfYear = +1
		let date: NSDate = cal.dateByAddingComponents(components, toDate: monday!, options: nil)!
		println(monday!)
		println(date)
		let newWeek = cal.components(NSCalendarUnit.WeekOfYearCalendarUnit, fromDate: date).weekOfYear as Int
		let newYear = cal.components(NSCalendarUnit.YearForWeekOfYearCalendarUnit, fromDate: date).yearForWeekOfYear as Int
		
		if date.compare(currentMonday!) == NSComparisonResult.OrderedSame {
			nextButton.enabled = false
		}

		self.week = "\(newWeek) \(newYear)"
		updateWebView()
		self.title = "Uke \(self.week!)"
		let url:NSURL = NSBundle.mainBundle().URLForResource("Export", withExtension: "html")!
		cool.loadRequest(NSURLRequest(URL: url))
	}
	*/
	
	override func viewDidLoad() {
		//nextButton.enabled = false;
		self.title = "Fraværsskjema"
		//self.week = currentWeek!
		cool.delegate = self

		let url:NSURL = NSBundle.mainBundle().URLForResource("Export", withExtension: "html")!
		cool.loadRequest(NSURLRequest(URL: url))
		composer.mailComposeDelegate = self
		
		if (!NSUserDefaults.standardUserDefaults().boolForKey("share")){
			let alert = UIAlertController(title: "Instruksjoner", message: "For å sende eller lagre skjemaet over timer uten undervisning, trykk på knappen nede i midten.", preferredStyle: UIAlertControllerStyle.Alert)
			let finished = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
			alert.addAction(finished)
			self.presentViewController(alert, animated: true, completion: nil)
			NSUserDefaults.standardUserDefaults().setBool(true, forKey: "share")
		}
	}
	func webViewDidFinishLoad(webView: UIWebView) {
		var error:NSError?
		let json: NSData?
		do {
			json = try NSJSONSerialization.dataWithJSONObject(self.data!, options: [])
		} catch let error1 as NSError {
			error = error1
			json = nil
		}
		let string = "loadData('" + NSString(data: json!, encoding: NSUTF8StringEncoding)!.stringByReplacingOccurrencesOfString("'", withString: "\\'") + "')"
		webView.stringByEvaluatingJavaScriptFromString(string)
		print(string)
	}
	
	func makePDF() -> NSData {
		let formatter = self.cool.viewPrintFormatter()
		let renderer:BNHtmlPdfKitPageRenderer = BNHtmlPdfKitPageRenderer()
		renderer.topAndBottomMarginSize = 0.5 * 72.0;
		renderer.leftAndRightMarginSize = 0.1 * 72.0;
		renderer.addPrintFormatter(formatter, startingAtPageAtIndex: 0)
		let mutableData = NSMutableData()
		
		let pageSize = CGSizeMake(8.26666667 * 72, 11.6916667 * 72);
		let pageRect = CGRectMake(0, 0, pageSize.width, pageSize.height);
		
		UIGraphicsBeginPDFContextToData(mutableData, pageRect, nil);
		
		let pages = renderer.numberOfPages()
		renderer.prepareForDrawingPages(NSMakeRange(0, pages))
		
		for (var i = 0; i < pages; i++) {
			UIGraphicsBeginPDFPage();
			renderer.drawPageAtIndex(i, inRect: renderer.paperRect)
		}
		
		UIGraphicsEndPDFContext();
		return NSData(data: mutableData)
	}
	
	@IBAction func sendPDF(sender: AnyObject) {
		let action = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
		let email = UIAlertAction(title: "Send som epost", style: UIAlertActionStyle.Default) { (action) -> Void in
			self.emailPDF()
		}
		let save = UIAlertAction(title: "Lagre til Bilder", style: UIAlertActionStyle.Default) { (action) -> Void in
			self.saveImage()
		}
		let destruct = UIAlertAction(title: "Nullstill fraværsskjema", style: UIAlertActionStyle.Destructive) { (action) -> Void in
			self.destruct()
		}
		let cancel = UIAlertAction(title: "Avbryt", style: UIAlertActionStyle.Cancel, handler: nil)
		action.addAction(email)
		action.addAction(save)
		action.addAction(destruct)
		action.addAction(cancel)
		self.presentViewController(action, animated: true, completion: nil)
	}
	func emailPDF(){
		let pdfData:NSData = makePDF()
		composer.setSubject("Fraværsføringsskjema")
		composer.addAttachmentData(pdfData, mimeType: "application/pdf", fileName: "Fraværsføringsskjema.pdf")
		self.presentViewController(composer, animated: true, completion: nil)
	}
	func saveImage(){
		let pdfData:NSData = makePDF()
		let pdf = CGPDFDocumentCreateWithProvider(CGDataProviderCreateWithCFData((pdfData as CFDataRef)))
		let pageCount = CGPDFDocumentGetNumberOfPages(pdf)
		for (var i = 1; i <= pageCount; i++){
			let pageRef = CGPDFDocumentGetPage(pdf, i)
			UIImageWriteToSavedPhotosAlbum(convertPDFPageToImage(pageRef!, resolution: 144), nil, nil, nil)
		}
		let action = UIAlertController(title: ("Lagret \(pageCount) bilde" + ((pageCount == 1) ? "" : "r") + " til Bilder-appen"), message: "", preferredStyle: UIAlertControllerStyle.Alert)
		let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
		action.addAction(ok)
		self.presentViewController(action, animated: true, completion: nil)
	}
	

	func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
		self.dismissViewControllerAnimated(true, completion: nil)
		if (result.rawValue == MFMailComposeResultSent.rawValue) {
			print("Sent")
		}
	}
	func destruct(){
		let alert = UIAlertController(title: "Tøm data", message: "Vil du nullstille fraværsskjemaet? Dette vil slette alle data, og handlingen kan ikke angres!", preferredStyle: UIAlertControllerStyle.Alert)
		let finished = UIAlertAction(title: "Nei, behold data", style: UIAlertActionStyle.Cancel, handler: nil )
		let destruct = UIAlertAction(title: "Ja, nullstill skjemaet", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
			var day = NSDate()
			let end = day.dateByAddingTimeInterval(-356*24*60*60)
			let dateFormatter = NSDateFormatter()
			dateFormatter.dateFormat = "ddMMyy"
			while (day != end){
				let dayString = dateFormatter.stringFromDate(day)
				print(dayString)
				if let this: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(dayString) {
					NSUserDefaults.standardUserDefaults().removeObjectForKey(dayString)
				}
				day = day.dateByAddingTimeInterval(-24*60*60)
			}
			self.navigationController?.popViewControllerAnimated(true)
		})
		alert.addAction(finished)
		alert.addAction(destruct)
		self.presentViewController(alert, animated: true, completion: nil)
	}
	func convertPDFPageToImage(page:CGPDFPageRef, resolution: Float) -> UIImage {
		let cropBox = CGPDFPageGetBoxRect(page, CGPDFBox.CropBox)
		
		let pageRotation = CGPDFPageGetRotationAngle(page)
		let scale = resolution / 72
		if ((pageRotation == 0) || (pageRotation == 180) || (pageRotation == -180)) {
			UIGraphicsBeginImageContextWithOptions(cropBox.size, false, CGFloat(scale))
		}
		else {
			UIGraphicsBeginImageContextWithOptions(CGSizeMake(cropBox.size.height, cropBox.size.width), false, CGFloat(scale))
		}
		let imageContext = UIGraphicsGetCurrentContext()
		PDFPageRenderer.renderPage(page, inContext: imageContext)
		let pageImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return pageImage
	}

}

