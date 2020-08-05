//
//  AppDelegate.swift
//  NASA
//
//  Created by Anastasiya Osinskaya on 8/5/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let tabBarController = UITabBarController()
        let dailyPictureViewController = DailyPictureViewController()
        let marsWeatherViewController = MarsWeatherViewController()
        let earthPictureViewController = EarthPictureViewController()
        
        let tabIcon1 = UITabBarItem(title: nil, image: UIImage(named: "1"), tag: 0)
        let tabIcon2 = UITabBarItem(title: nil, image: UIImage(named: "1"), tag: 0)
        let tabIcon3 = UITabBarItem(title: nil, image: UIImage(named: "1"), tag: 0)
        
        dailyPictureViewController.tabBarItem = tabIcon1
        marsWeatherViewController.tabBarItem = tabIcon2
        earthPictureViewController.tabBarItem = tabIcon3
        
        let controllers = [dailyPictureViewController,marsWeatherViewController,earthPictureViewController]
        tabBarController.viewControllers = controllers
        let navigationController = UINavigationController(rootViewController: tabBarController)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = navigationController
        
        return true
    }
    
    
}

