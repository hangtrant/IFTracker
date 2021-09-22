//
//  GoalViewController.swift
//  IFTracker
//
//  Created by チャン　トゥハン on 2021/09/13.
//

import UIKit

class GoalViewController: UIViewController {
    var newGoal = 16
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func for16hoursButton(_ sender: Any) {
        newGoal = 16
    }
    @IBAction func for18hoursButton(_ sender: Any) {
        newGoal = 18
    }
    @IBAction func for20hoursButton(_ sender: Any) {
        newGoal = 20
    }
    @IBAction func for24hoursButton(_ sender: Any) {
        newGoal = 24
    }
    @IBAction func for36hoursButton(_ sender: Any) {
        newGoal = 36
    }
}
