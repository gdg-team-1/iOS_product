//
//  StationViewController.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/09.
//

import UIKit

class StationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        performSegue(withIdentifier: "showForm", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let naviVC = segue.destination as? UINavigationController,
              let dest = naviVC.viewControllers.first as? FormViewController else { return }
        dest.willDismissFormVC = { [weak self] in
            self?.tabBarController?.selectedIndex = 0
        }
    }
}
