//
//  AppDelegate.swift
//  PasswordGen
//
//  Created by Naresh Kumar Nagulavancha on 11/4/16.
//  Copyright © 2016 Incomm. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate,NSMenuDelegate{

	@IBOutlet weak var window: NSWindow!
	let statusItem = NSStatusBar.system().statusItem(withLength: -2)

	let alphabets = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	let number = "1234567890"
	let special = "!@#$%^&*"
	var date:NSDate?

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		statusItem.image = #imageLiteral(resourceName: "passCode")

		let menu = NSMenu()
		menu.addItem(NSMenuItem(title: "Copy Password", action: #selector(copyPassword(_:)), keyEquivalent: "P"))
		menu.addItem(NSMenuItem.separator())
		menu.addItem(NSMenuItem(title: "Change Password", action: #selector(changePassword(_:)), keyEquivalent: "C"))
		menu.addItem(NSMenuItem.separator())
		let item = NSMenuItem(title: "Show Passowrd", action: #selector(showPassword(_:)), keyEquivalent: "")
		let subMenu = NSMenu()
		let menuItem = NSMenuItem(title: "Helo", action: nil, keyEquivalent: "")
		menuItem.isEnabled = false
		subMenu.addItem(menuItem)
		item.submenu = menu
		menu.addItem(item)

		statusItem.menu = menu

		let notification:NSUserNotification = NSUserNotification()
		notification.deliveryDate = NSDate(timeIntervalSinceNow: 5) as Date
		notification.title = "Reminder"
		let action:NSUserNotificationAction = NSUserNotificationAction(identifier: "action", title: "Change Password")
		notification.additionalActions = [action]

		notification.soundName = NSUserNotificationDefaultSoundName
		let notificationCenter = NSUserNotificationCenter.default
		notificationCenter.delegate = self
		notificationCenter.scheduleNotification(notification)

	}


	func copyPassword(_ sender: AnyObject){
		NSPasteboard.general().clearContents()
		NSPasteboard.general().setString(PasswordManager.shared.password!, forType: NSStringPboardType)
	}

	func changePassword(_ sender: AnyObject){
		let menu = NSMenu()
		PasswordManager.shared.password = generatePassword()
		self.date = NSDate()
	}

	func showPassword(_ sender: AnyObject){

		let menu = NSMenu()
		let menuItem = NSMenuItem(title: PasswordManager.shared.password!, action: nil, keyEquivalent: "")
		menuItem.isEnabled = false
		menu.addItem(menuItem)
		(sender as! NSMenuItem).submenu = menu

	}

	func generatePassword() -> String {
		var pass = ""
		for _ in 0...10{
			pass = pass + String(alphabets.characterAtIndex())
		}
		for _ in 10...14{
			pass = pass + String(number.characterAtIndex())
		}
		for _ in 14...16{
			pass = pass + String(special.characterAtIndex())
		}
		return pass
	}


	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
		return true
	}


}

extension String {
	func characterAtIndex() -> Character {
		let c = self.index(self.startIndex, offsetBy: String.IndexDistance(arc4random_uniform(UInt32(self.characters.count))))
		return self[c]
	}
}

