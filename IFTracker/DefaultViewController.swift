//
//  DefaultViewController.swift
//  IFTracker
//
//  Created by チャン　トゥハン on 2021/09/13.
//

import UIKit
import RealmSwift

class DefaultViewController: UIViewController {
    let realm = try! Realm()
    let user = User()
    
    @IBOutlet weak var nicknameTextField: UITextField!
    
    //スタットボタンを押すとき
    @IBAction func handleStartButton(_ sender: Any) {
        if let nickname = nicknameTextField.text {
            if nickname.isEmpty {
                return
            }
        }
        user.nickname = nicknameTextField.text!
        try! realm.write() {
            realm.add(user)
        }
        
        let storyboard = self.storyboard!
        let home = storyboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        home.outputValue = self.nicknameTextField.text
        // 画面を閉じてタブ画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
