//
//  NotificationTestDialogViewController.swift
//  Nexpil
//
//  Created by Guang on 9/30/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationTestDialogViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var initialMinute: UITextField!
    @IBOutlet weak var initialMessage: UITextView!
    @IBOutlet weak var drugNameLabel: UILabel!
    @IBOutlet weak var reminderMinute: UITextField!
    @IBOutlet weak var reminderMessage: UITextView!
    @IBOutlet weak var reminderTimes: UITextField!
    
    var drugName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drugNameLabel.text = drugName
    }
    

    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
    
    @IBAction func closeDialog(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveButtonClick(_ sender: UIButton) {
        showTestNotification()
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func showTestNotification() {
        
        let initMin = Int(initialMinute.text ?? "0")!
        let initSecond = initMin * 60

        let content = UNMutableNotificationContent()

        content.title = "Initial Reminder"
        content.body = initialMessage.text
        content.sound = .default()
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(initSecond), repeats: false)
        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)


        UNUserNotificationCenter.current().add(request, withCompletionHandler: { _ in
        })

        let reminderRepeatCount = Int(reminderTimes.text ?? "0")!
        for i in 0...reminderRepeatCount {
            let reminderContent = UNMutableNotificationContent()
            reminderContent.title = "After Reminder"
            reminderContent.body = self.reminderMessage.text
            reminderContent.sound = .default()
            reminderContent.badge = 1

            let reminderMin = Int(self.reminderMinute.text ?? "0")!
            let reminderSecond = (reminderMin+i) * 60 + initSecond

            let reminderTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(reminderSecond), repeats: false)
            let reminderRequest = UNNotificationRequest(identifier: "reminder", content: reminderContent, trigger: reminderTrigger)

            UNUserNotificationCenter.current().add(reminderRequest, withCompletionHandler: nil)

        }
    }
}
