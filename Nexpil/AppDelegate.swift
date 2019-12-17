//
//  AppDelegate.swift
//  Nexpil
//
//  Created by Admin on 4/3/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications
import Alamofire

var App: AppDelegate!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,UNUserNotificationCenterDelegate {

    var window: UIWindow?
//    var manager = DataManager()
    
    var pageViewController: PageViewController?
    var vitaminPageViewController: VitaminPageViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        App = self

//         keyboard
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        if UserDefaults.standard.value(forKey: "id") != nil{
            show(window: window!)
        }
        else{
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingScreenViewController") as! LandingScreenViewController
            window!.rootViewController = viewController
        }
        
        // keyboard
//        IQKeyboardManager.sharedManager().enable = true
        
        Global_SetGlassEffect()
        Global_SetGlassEffect1()

        self.SetupPushNOtification(application: application)
        return true
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func show(window:UIWindow){
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainviewcontroller") as! UITabBarController
        viewController.tabBar.layer.cornerRadius = 10
        viewController.tabBar.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner];
        viewController.tabBar.layer.borderWidth = 1
        viewController.tabBar.layer.borderColor = UIColor(red: (112/255.0), green: (112/255.0), blue: (112/255.0), alpha: 0.2).cgColor
        viewController.tabBar.clipsToBounds = true
//        viewController.selectedIndex = 2
        window.rootViewController = viewController
    }
    
    // Setup app delegate for push notifications
    func SetupPushNOtification(application: UIApplication) -> () {
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {(granted, error) in
            print("granted: \(granted)")
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                    
                    let snoozeAction = UNNotificationAction(
                      identifier: "snooze", title: "Snooze",
                      options: [.foreground])
                    
                    // 2
                    let snoozeCategory = UNNotificationCategory(
                      identifier: "snoozeCategory", actions: [snoozeAction],
                      intentIdentifiers: [], options: [])

                    // 3
                    UNUserNotificationCenter.current().setNotificationCategories([snoozeCategory])
                }
            } else {
                print("User Notification permission denied: \(error?.localizedDescription ?? "error")")
            }
        })
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Message received")
        
        let userInfo = response.notification.request.content.userInfo
       
        if let aps = userInfo["aps"] as? [String: AnyObject] {
             if response.actionIdentifier == "snooze" {
                // Set Snooze post action
                let params = [
                    "snooze": PreferenceHelper().getSnooze(),
                    "userid": PreferenceHelper().getId()
                ]
                Alamofire.request(DataUtils.APIURL + DataUtils.NOTIFICATION_URL, method: .post, parameters: params).responseString { response in
                    print(response)
                }
             }
        }
    
        completionHandler()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Successful registration. Token is:")
        print(tokenString(deviceToken))
        UserDefaults.standard.set(tokenString(deviceToken), forKey: "DeviceToken")
        
        // Update deviceToken and timezone
        let localTimeZoneName = TimeZone.current.identifier
        let deviceToken = tokenString(deviceToken)
        let params1 = [
            "userid": PreferenceHelper().getId(),
            "timezone": localTimeZoneName,
            "deviceToken": deviceToken,
            "choice": 2
            ] as [String : Any]
        
        Alamofire.request(DataUtils.APIURL + DataUtils.PATIENT_URL, method: .post, parameters: params1).responseString { response in
            print(response)
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for rmote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
    }
    
    func tokenString(_ deviceToken: Data) -> String {
        let bytes = [UInt8](deviceToken)
        var token = ""
        for byte in bytes {
            token += String(format: "%02x", byte)
        }
        return token
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if DBManager.getObject().createDatabase() {
            
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        self.saveContext()
    }

    // MARK: - Core Data stack
    //    lazy var persistentContainer: NSPersistentContainer = {
    @objc var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Nexpil")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
}

