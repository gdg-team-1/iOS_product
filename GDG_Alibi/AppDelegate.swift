//
//  AppDelegate.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/05.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 파이어베이스 설정
        FirebaseApp.configure()
        // 인트로 화면 보여주기
        fetchIntro()

        return true
    }

    private func fetchIntro() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let introVC = storyBoard.instantiateViewController(withIdentifier: IntroViewController.id) as? IntroViewController else { return }
        window?.rootViewController = introVC
        window?.makeKeyAndVisible()
    }

    public func showHome() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateInitialViewController() as? MainTabBarController else { return }
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}

