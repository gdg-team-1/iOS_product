//
//  IntroViewController.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/09.
//

import UIKit

final class IntroViewController: UIViewController, ViewInfo {

    static var id = "IntroViewController"

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        fetchLocation()
    }

    private func initView() {
        activityIndicator.startAnimating()
    }

    private func fetchLocation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25, execute: {
            LocationManager.shared.fetchLocationList { [weak self] in
                self?.showMainVC()
            }
        })
    }

    private func showMainVC() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        if LocationManager.shared.isLocationEmpty || BasicUserInfo.shared.isUserInfoEmpty {
            let storyBoard = UIStoryboard(name: "Location", bundle: nil)
            guard let vc = storyBoard.instantiateInitialViewController() as? UINavigationController else { return }
            appDelegate.window?.rootViewController = vc
            appDelegate.window?.makeKeyAndVisible()
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyBoard.instantiateViewController(withIdentifier: MainTabBarController.id) as? MainTabBarController else { return }
            appDelegate.window?.rootViewController = vc
            appDelegate.window?.makeKeyAndVisible()
        }
    }
}
