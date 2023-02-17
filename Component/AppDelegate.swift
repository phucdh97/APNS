//
//  AppDelegate.swift
//  Component
//
//  Created by Do Huu Phuc on 19/01/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var apnsManager = APNSManager.shared
    
    // launch app
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("Notif - Did finish launching with options: \(String(describing: launchOptions))")
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        let vc = APNSViewController()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        apnsManager.viewDebug = vc
        

        apnsManager.handleApplication(application, didFinishLaunchingWithOptions: launchOptions)
        /// Register RemoteNotification
        apnsManager.registerForRemoteNotifications { success in
            //
        }
        
        return true
    }

    // MARK: Notif
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        apnsManager.handleApplication(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        apnsManager.handleApplication(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    
    // slient push, background, forceground
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        apnsManager.handleApplication(application,
                                      didReceiveRemoteNotification: userInfo,
                                      fetchCompletionHandler: completionHandler)
        
    }


}

