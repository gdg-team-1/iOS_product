//
//  MainTabBarController.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/05.
//

import UIKit

final class MainTabBarController: UITabBarController, ViewInfo {

    static var id: String = "MainTabBarController"

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.1529411765, green: 0.231372549, blue: 0.2823529412, alpha: 1)
        tabBar.tintColor = #colorLiteral(red: 0.1725490196, green: 0.7803921569, blue: 0.5058823529, alpha: 1)
    }

}
