//
//  AppDelegate+Push.swift
//  PassLock
//
//  Created by Melo Dreek on 2023/5/5.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

extension AppDelegate {
    @objc func registerLocalNotification() {
        
        let _ = LocalNotificationManager.shared
        
        if AppLocalManager.shared.isRegisterLocalPush {
            return
        }

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            guard success else { return }
            let _ = LocalNotiPushManager.shared
            let _ = LocalNotificationManager.shared
            self.registerLocalPush()
        }
            
    }
    
    private func registerLocalPush() {
        let content = UNMutableNotificationContent.init()
        content.title = "PassLock: Open Source Password Manager".localStr()
        content.body = "Do you have any confidential data to keep today?".localStr()
        content.badge = NSNumber(value: 1)
        content.userInfo = [:]
        content.sound = UNNotificationSound.default
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nowDate = Date()
        
        let month = nowDate.month < 10 ? "0\(nowDate.month)" : "\(nowDate.month)"
        let day = nowDate.day < 10 ? "0\(nowDate.day)" : "\(nowDate.day)"
        let date = formatter.date(from: "\(nowDate.year)-\(month)-\(day) 21:25:00")
        
        let dateSet: Set<Calendar.Component> = [.hour, .minute, .second]
        let components = NSCalendar.current.dateComponents(dateSet, from: date ?? nowDate)
        
        let notiTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let notiRequest = UNNotificationRequest(identifier: kSecretVaultPushKey, content: content, trigger: notiTrigger)
        
        UNUserNotificationCenter.current().add(notiRequest) { error in
            guard let vError = error else {
                AppLocalManager.shared.isRegisterLocalPush = true
                return
            }
            
            debugPrint("❌PUSH = \(vError.localizedDescription)")
        }
    }
    
    func removePushNotiBadge() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
