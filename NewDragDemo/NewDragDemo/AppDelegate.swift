//
//  AppDelegate.swift
//  NewDragDemo
//
//  Created by Allen long on 2022/5/19.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DataSourceManager.main.fetchFromDisk()
        return true
    }


}

