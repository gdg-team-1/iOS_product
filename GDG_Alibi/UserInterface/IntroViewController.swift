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

    let dispatchQueue = DispatchQueue(label: "intro request", qos: .background, attributes: .concurrent)
    let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        fetchInfo()
    }

    private func initView() {
        activityIndicator.startAnimating()
    }

    private func fetchInfo() {
        self.dispatchGroup.enter()
        self.dispatchQueue.async {
            self.fetchLocation()
        }

        if !BasicUserInfo.shared.isFirstLaunch {
            self.dispatchGroup.enter()
            self.dispatchQueue.async {
                self.fetchUserInfo()
            }
        }

        self.dispatchGroup.notify(queue: .main) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                self?.showMainVC()
            }
        }
    }

    private func fetchLocation() {
        LocationManager.shared.fetchLocationList { [weak self] in
            self?.dispatchGroup.leave()
        }
    }

    private func fetchUserInfo() {
        BasicUserInfo.shared.getUserInfo { failMsg in
            if let failMsg = failMsg {
                let alert = UIAlertController(title: "알림", message: failMsg, preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }

            self.dispatchGroup.leave()
        }
    }

    private func showMainVC() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        if LocationManager.shared.isLocationEmpty {
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
