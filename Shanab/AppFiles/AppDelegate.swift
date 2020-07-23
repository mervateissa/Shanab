//
//  AppDelegate.swift
//  Shanab
//
//  Created by Macbook on 3/22/20.
//  Copyright © 2020 Dtag. All rights reserved.
//


import UIKit
import CoreData
import UserNotifications
import Firebase
import FirebaseMessaging
import IQKeyboardManagerSwift
import MOLH
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MOLHResetable {
    static var type = String()
    static var body = String()
    let token = Helper.getApiToken() ?? ""
    func reset() {
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        if self.token == "" {
            let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeNav")
            rootviewcontroller.rootViewController = sb
            Singletone.instance.appUserType = .guest
        } else {
            if let customer_type = Helper.getUserRole() {
                switch customer_type {
                case "Driver":
                    let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeNav")
                    rootviewcontroller.rootViewController = sb
                    Singletone.instance.appUserType = .Driver
                case "Customer":
                    let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeNav")
                    rootviewcontroller.rootViewController = sb
                    Singletone.instance.appUserType = .Customer
                default:
                    let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeNav")
                    rootviewcontroller.rootViewController = sb
                    Singletone.instance.appUserType = .guest
                }
            }
        }
        
    }
    static var item_id = Int()
    static var notification_flag = false
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        //
        if ("lang".localized == "en") {
            MOLHLanguage.setDefaultLanguage("en")
        } else {
            MOLHLanguage.setDefaultLanguage("ar")
        }
        MOLH.shared.activate(true)
        MOLH.shared.specialKeyWords = ["Cancel","Done"]
        // Override point for customization after application launch.
        //        UIApplication.shared.statusBarStyle = .lightContent // .default
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        //                MOLH.reset()
        //         [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        if let api_token = Helper.getApiToken() {
            print("api_token: \(api_token)")
            if let customer_type = Helper.getUserRole() {
                switch customer_type {
                case "Customer":
                    let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeNav")
                    window?.rootViewController = sb
                    Singletone.instance.appUserType = .Customer
                case "Driver":
                    let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeNav")
                    window?.rootViewController = sb
                    Singletone.instance.appUserType = .Driver
                default:
                    let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeNav")
                    window?.rootViewController = sb
                    Singletone.instance.appUserType = .guest
                }
            }
        }
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = #colorLiteral(red: 0.9195484519, green: 0.2682709396, blue: 0.21753335, alpha: 1)
            appearance.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
            appearance.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
            
            UINavigationBar.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UINavigationBar.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.9195484519, green: 0.2682709396, blue: 0.21753335, alpha: 1)
            UINavigationBar.appearance().isTranslucent = false
        }
        // [END register_for_notifications]
        return true
    }
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
   func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("APNs token retrieved: \(deviceToken)")
    Messaging.messaging().apnsToken = deviceToken
    InstanceID.instanceID().instanceID { (result, error) in
        if let error = error {
            print("Error Fetching Remote Instance ID: \(error)")
        } else if let result = result {
            print("Remote Instance ID Token: \(result.token)")
            Helper.saveDeviceToken(token: result.token)
            //                Services.postSetToken(token: result.token, type: "ios") { (error: Error?, result: SuccessError_Model?) in
            if Helper.getApiToken() ?? "" != "" {
                switch Helper.getUserRole() ?? "" {
                case "Customer":
                    Services.postUserSetToken(type: "ios", device_token: Helper.getDeviceToken() ?? "") { (error: Error?, result: SuccessError_Model?) in

                    }
                    case "Driver":
                        Services.postDriverSetToken(type: "ios", device_token: result.token) {(error: Error?, result: SuccessError_Model?) in
                            
                    }
                    default:
                        break
                    }
                    
                }
            }
            
        }
    }
    // With swizzling disabled you must set the APNs token here.
    // Messaging.messaging().apnsToken = deviceToken
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
}

func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    CoreDataService.saveContext()
}

//}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        let type = userInfo["type"] as? String ?? ""
        let item_id = userInfo["item_id"] as? String ?? ""
        let body = userInfo["body"] as? String ?? ""
        print(type)
        print(item_id)
        print(body)
        if let type = userInfo["type"] as? String, let body = userInfo["body"] as? String, let item_id = userInfo["item_id"] as? String {
            switch Singletone.instance.appUserType {
            case .Driver:
                switch type {
                case "newRequest":
                    let sb = UIStoryboard(name: "DeliveryMan", bundle: nil).instantiateViewController(withIdentifier: "ChartNav")
                    AppDelegate.item_id = Int(item_id) ?? 0
                    AppDelegate.notification_flag = true
                    window?.rootViewController = sb

                default:
                    break
                }
            case .Customer:
                switch type {
                case "newRequest":
                    let sb = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "CustomerProfileNav")
                    AppDelegate.item_id = Int(item_id) ?? 0
                    AppDelegate.notification_flag = true
                    window?.rootViewController = sb
                case "offer":
                    let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "SalesCategoriesNav")
                    AppDelegate.item_id = Int(item_id) ?? 0
                    AppDelegate.notification_flag = true
                    window?.rootViewController = sb
                case "order":
                    let sb = UIStoryboard(name: "OrderDetails", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailsNav")
                    AppDelegate.item_id = Int(item_id) ?? 0
                    AppDelegate.notification_flag = true
                    window?.rootViewController = sb

                default:
                    break
                }
            default:
                break
            }



        }
        
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}


extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


