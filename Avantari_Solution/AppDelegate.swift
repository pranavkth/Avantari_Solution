//
//  AppDelegate.swift
//  Avantari_Assignment
//
//  Created by pranav gupta on 05/05/17.
//  Copyright © 2017 Pranav gupta. All rights reserved.
//

import UIKit
import UserNotifications
import SocketIO
import Charts

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate{
    
    var window: UIWindow?
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([UNNotificationPresentationOptions.alert, UNNotificationPresentationOptions.sound])
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Authorisation Request To Enable Notifications.
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
            (accepted,error) in
            if !accepted {
                print("notification access denied")
            }
            
        }
        
        // Fetching the Persistent Data From UserDefaults.
        
        if defaults.dictionaryRepresentation().index(forKey: "persistentCollectiondata") != nil {
            
            guard let info = defaults.object(forKey: "persistentCollectiondata") as? NSData else{print("error in getting info"); return true}
            guard let persistentData = NSKeyedUnarchiver.unarchiveObject(with: info as Data) as? [ServerData] else {print("error in getting persistent data"); return true}
            print("persistentdatacount", persistentData.count)
            persistentDataGlobal = persistentData
            
        }
            
        else{
            
            let info = NSKeyedArchiver.archivedData(withRootObject: persistentDataGlobal)
            defaults.set(info, forKey: "persistentCollectiondata")
        }
        
        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        // Closing the Connection when the app enters background and saving data to userdefaults.
        
        socket.disconnect()
        let info = NSKeyedArchiver.archivedData(withRootObject: persistentDataGlobal)
        defaults.set(info, forKey: "persistentCollectiondata")
        defaults.synchronize()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // Establishing the connection with the server once the app becomes Active.
        
        socket.connect()
        
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        let info = NSKeyedArchiver.archivedData(withRootObject: persistentDataGlobal)
        defaults.set(info, forKey: "persistentCollectiondata")
        defaults.synchronize()
        
    }
    
    // Function for Scheduling Notification.
    
    func scheduleNotification(at date: Date){
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute, second: components.second! + 2)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "Number Repeated"
        content.body = String(persistentDataGlobal[persistentDataGlobal.count - 1].number) + "  " +  " Number Repeated"
        content.sound = UNNotificationSound(named: "alert.caf")
        let request = UNNotificationRequest(identifier: "repeatednumber", content: content, trigger: trigger)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request){
            error in
            if let error = error {
                print ("error in notification",error)
            }
        }
        
    }
    
}

let delegate = UIApplication.shared.delegate as? AppDelegate



