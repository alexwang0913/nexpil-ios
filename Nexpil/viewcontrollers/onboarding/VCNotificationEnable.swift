//
//  VCNotificationEnable.swift
//  Nexpil
//
//  Created by mac on 7/2/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import UserNotifications
import Alamofire

class VCNotificationEnable: UIViewController, UNUserNotificationCenterDelegate {

    public var isCommunityUser = false
    public var m_communityUserData: [String: Any]!
    @IBOutlet weak var btnAllow: NPButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isCommunityUser == false {
            btnAllow.setValue(0, forKey: "colorScheme")
        }
    }
    
    @IBAction func onEnable(){
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound, .badge]) { (auth, error) in
            if auth {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    
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
            }
            if self.isCommunityUser == true {
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainviewcontroller") as! UITabBarController
                let vc_community = viewController.viewControllers![2] as! CommunityMainViewController
                vc_community.showCongPopup = true
                vc_community.m_communityUserData = self.m_communityUserData
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = viewController
            } else {
                DispatchQueue.main.async {
                    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainviewcontroller") as! UITabBarController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = viewController
                    viewController.modalPresentationStyle = .overFullScreen
                    self.present(viewController, animated: false, completion: nil)
                }
            }
        }
        
        // 1
    }
    
    func SetupPushNOtification(application: UIApplication) -> () {
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {(granted, error) in
            print("granted: \(granted)")
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                print("User Notification permission denied: \(error?.localizedDescription ?? "error")")
            }
        })
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UserDefaults.standard.set(tokenString(deviceToken), forKey: "DeviceToken")
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
}
