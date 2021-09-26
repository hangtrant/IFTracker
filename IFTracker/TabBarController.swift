//
//  TabBarController.swift
//  IFTracker
//
//  Created by チャン　トゥハン on 2021/09/13.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        // タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        // UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する。
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            if viewController is GoalViewController {
                // GoalViewController
                let goalViewController = storyboard!.instantiateViewController(withIdentifier: "Goal")
                present(goalViewController, animated: true)
                return false
            } else {
                // その他のViewControllerは通常のタブ切り替えを実施
                return true
            }
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //この下の7行を追加
        let ud = UserDefaults.standard
        let firstLunchKey = "firstLunch"
        if ud.bool(forKey: firstLunchKey) {
        ud.set(false, forKey: firstLunchKey)
        ud.synchronize()
        let defaultViewController = self.storyboard?.instantiateViewController(withIdentifier: "Default")
        self.present(defaultViewController!, animated: true, completion: nil)
        }
    }
}
