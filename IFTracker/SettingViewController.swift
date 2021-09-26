//
//  SettingViewController.swift
//  IFTracker
//
//  Created by チャン　トゥハン on 2021/09/13.
//

import UIKit
import RealmSwift

class SettingViewController: UIViewController {
    let realm = try! Realm()
    
    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBAction func handleChangeNicknameButton(_ sender: Any) {
        if let nickname = nicknameTextField.text {
            if nickname.isEmpty {
                return
            }
        }
        let user = realm.objects(User.self).last
        try! realm.write() {
            user?.nickname = nicknameTextField.text!
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = realm.objects(User.self).last
        nicknameTextField.text = user?.nickname
        
        // Do any additional setup after loading the view.
    }

}
