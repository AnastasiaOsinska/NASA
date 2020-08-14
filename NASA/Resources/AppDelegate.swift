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
        let marsPhotoViewController = MarsPhotoViewController()
        let earthPictureViewController = EarthPictureViewController()
        
        let tabIcon1 = UITabBarItem(title: nil, image: UIImage(named: Constants.picture), tag: Constants.tag)
        let tabIcon2 = UITabBarItem(title: nil, image: UIImage(named: Constants.mars), tag: Constants.tag)
        let tabIcon3 = UITabBarItem(title: nil, image: UIImage(named: Constants.earth), tag: Constants.tag)
            
        dailyPictureViewController.tabBarItem = tabIcon1
        marsPhotoViewController.tabBarItem = tabIcon2
        earthPictureViewController.tabBarItem = tabIcon3
        
        let controllers = [dailyPictureViewController,marsPhotoViewController,earthPictureViewController]
        tabBarController.viewControllers = controllers
        
        let navigationController = UINavigationController(rootViewController: tabBarController)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = navigationController
        
        return true
    }
}

