//
//  APNSManager.swift
//  Component
//
//  Created by Do Huu Phuc on 20/01/2023.
//

import Foundation
import UIKit


class APNSManager: NSObject {
    
    public static let shared = APNSManager()
    public var viewDebug: APNSViewController?
    
    // MARK: Public functions
    
    public func registerForRemoteNotifications(completionHandler: @escaping (Bool) -> Void) {
        
        let center = UNUserNotificationCenter.current()
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        center.requestAuthorization(options: authOptions) { [weak self] granted, error in
            print("Request granted: \(granted)")
            if granted {
                self?.tryToRegisterForRemoteNotification()
                completionHandler(true)
            }
            
            if error != nil || !granted {
                print("Request permission error: \(String(describing: error))")
                completionHandler(false)
            }
        }
    }
    
    public func unregisterForRemoteNotifications() {
        DispatchQueue.main.async {
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    
    public func handleApplication(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token: String = deviceToken.map { data in
            String(format: "%0.2.2hhx", data)
        }.joined()
        
        print("Notif - Device token :\(token)")
    }
    
    public func handleApplication(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Notif - Did failed to register remote notif with error: \(error)")
    }
    
    public func handleApplication(_ application: UIApplication,
                                  didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any]?) {
        guard let notifyInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String : AnyObject] , notifyInfo.count > 0 else { return }
        self.handleLaunchingApp(data: notifyInfo)
    }
    
    public func handleApplication(_ application: UIApplication,
                                  didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                                  fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("Notif - Did receive remote notif: \(userInfo)")
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
          completionHandler(.failed)
          return
        }
        
        if aps["content-available"] as? Int == 1 {
            self.handleSilentPushNotifications(data: userInfo)
        } else {
            let stateApp = UIApplication.shared.applicationState
            if stateApp != .active {
                self.handleRemotePushNotifications(data: userInfo)
            }
        }
        completionHandler(.newData)
    }
    
    
    // MARK: Private functions
    
    private func tryToRegisterForRemoteNotification() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    
    // MARK: Support test
    
    private func handleSilentPushNotifications(data: [AnyHashable : Any]) {
        guard let dict = data["suspend-data"] as? [String: String], let msg = dict["msg"] else { return }
        self.updateViewControllerText(text: msg)
    }
    
    private func handleLaunchingApp(data: [AnyHashable : Any]) {
        guard let dict = data["data"] as? [String: String], let msg = dict["msg"] else { return }
        self.updateViewControllerText(text: msg)
    }
    
    private func handleRemotePushNotifications(data: [AnyHashable : Any]) {
        guard let dict = data["data"] as? [String: String], let msg = dict["msg"] else { return }
        self.updateViewControllerText(text: msg)
    }
    
    private func updateViewControllerText(text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.viewDebug?.updateText(text: text)
        }
    }
    
}

