//
//  TabBarController.swift
//  CatDiary
//
//  Created by Hertz on 9/4/22.
//

import UIKit

class TabBarController: UITabBarController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tabBarHeigh: CGFloat = 85
        tabBar.frame.size.height = tabBarHeigh
        tabBar.frame.origin.y = view.frame.height - tabBarHeigh
    }

}
