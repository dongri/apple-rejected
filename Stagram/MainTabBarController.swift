//
//  MainTabBarController.swift
//  Stagram
//
//  Created by Dongri Jin on 3/19/16.
//  Copyright © 2016 Dongri Jin. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    var tabToday: UINavigationController!
    var tabPopular: UINavigationController!
    var tabUpcoming: UINavigationController!
    var tabSearch: UINavigationController!

    override func viewDidLoad() {
        super.viewDidLoad()

        tabToday = UINavigationController(rootViewController: TodayViewController())
        tabPopular = UINavigationController(rootViewController: PopularViewController())
        tabUpcoming = UINavigationController(rootViewController: UpcomingViewController())
        tabSearch = UINavigationController(rootViewController: SearchViewController())
        
        tabToday.tabBarItem = UITabBarItem(title: "Today", image: UIImage(named: "tab_feed.png"), tag: 1)
        tabPopular.tabBarItem = UITabBarItem(title: "Popular", image: UIImage(named: "tab_popular.png"), tag:2)
        tabUpcoming.tabBarItem = UITabBarItem(title: "Upcoming", image: UIImage(named: "tab_upcoming.png"), tag:3)
        tabSearch.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "tab_search.png"), tag: 4)
        
        let tabs = NSArray(objects: tabToday!, tabPopular!, tabUpcoming!, tabSearch!)

        self.setViewControllers(tabs as? [UIViewController], animated: false)
    }
}
