//
//  AppDelegate.swift
//  JSTestDemo
//
//  Created by 龚杰洪 on 16/6/13.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        copyWebDirToDocument()
        return true
    }
    
    func copyWebDirToDocument() {
        let fileManager = NSFileManager.defaultManager()
        guard let webDirBundlePath = NSBundle.mainBundle().pathForResource("HTML", ofType: nil) else {
            return
        }
        
        let documentsPath = NSString(string: fileManager.documentsPath)
        
        let webDirDocumentsPath = documentsPath.stringByAppendingPathComponent("HTML")
        
        if (fileManager.fileExistsAtPath(webDirBundlePath)) {
            do {
                if (fileManager.fileExistsAtPath(webDirDocumentsPath)) {
                    try fileManager.removeItemAtURL(NSURL(fileURLWithPath: webDirDocumentsPath))
                }
                try fileManager.copyItemAtURL(NSURL(fileURLWithPath: webDirBundlePath), toURL: NSURL(fileURLWithPath: webDirDocumentsPath))
            }
            catch {
                assert(false, "拷贝文件夹错误")
            }
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension NSFileManager {
    var documentsPath: String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        if (paths.count == 0) {
            return ""
        }
        let documentsDirectory = paths[0]
        
        return documentsDirectory
    }
    
    var cachesPath: String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        if (paths.count == 0) {
            return ""
        }
        let cachesDirectory = paths[0]
        
        return cachesDirectory
    }
}

