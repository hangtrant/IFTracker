//
//  ChartViewController.swift
//  IFTracker
//
//  Created by チャン　トゥハン on 2021/09/13.
//

import UIKit
import RealmSwift
import CloudKit

class ChartViewController: UIViewController {
    let realm = try! Realm()

    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var graphStackView: UIStackView!
    @IBOutlet weak var averageTimeLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.loadView()
        super.viewWillAppear(animated)
        
        graphView.layer.cornerRadius = 25
        setupGraph()
        // Do any additional setup after loading the view.
    }
    func setupGraph() {
        
        var sumTime = 0.0
        var count = 0
        let barWidth: CGFloat = 15
        let lastTracker = realm.objects(Tracker.self).last
        if lastTracker != nil {
            var condition = 0
            if lastTracker!.id >= 7 {
                condition = lastTracker!.id - 6
            }
            let tracker = realm.objects(Tracker.self).filter("id BETWEEN {\(condition), \(lastTracker!.id)}").sorted(byKeyPath: "startTime")
            for i in 0...(tracker.count - 1) {
                //Get tracking info
                let topH = (tracker[i]["elapsedTime"]) as! Int / 3600
                let bottomH = (tracker[i]["goalTime"]) as! Int / 3600
                sumTime += (tracker[i]["elapsedTime"]) as! Double
                count += 1
                print("SUMTIME")
                print(sumTime)
                
                let graphBottom = UIView()
                let graphTop = UIView()
                let graphLabel = UILabel()
                
                graphLabel.textColor = .gray
                graphLabel.font = UIFont.systemFont(ofSize: 12)
                
                setupInfo(label: graphLabel, index: i, trackerInfo : tracker)
                
                let graphStack = UIStackView()
                graphStack.axis = .vertical
                graphStack.spacing = 8
                graphStack.alignment = .center
                
                graphBottom.backgroundColor = UIColor.systemGray
                
                if topH >= bottomH {
                    graphTop.backgroundColor = UIColor.systemGreen
                } else {
                    graphTop.backgroundColor = UIColor.systemOrange
                }
                
                graphBottom.translatesAutoresizingMaskIntoConstraints = false
                graphTop.translatesAutoresizingMaskIntoConstraints = false
                graphLabel.translatesAutoresizingMaskIntoConstraints = false
                
                let constraints = [
                    graphBottom.widthAnchor.constraint(equalToConstant: barWidth),
                    graphTop.widthAnchor.constraint(equalToConstant: barWidth),
                    graphBottom.heightAnchor.constraint(equalToConstant: CGFloat(bottomH)),
                    graphTop.heightAnchor.constraint(equalToConstant: CGFloat(topH)),
                    graphTop.heightAnchor.constraint(equalToConstant: 60),
                    graphTop.bottomAnchor.constraint(equalTo: graphBottom.bottomAnchor),
                ]
                graphTop.layer.cornerRadius = barWidth / 2
                graphBottom.layer.cornerRadius = barWidth / 2
                
                graphBottom.addSubview(graphTop)
                
                NSLayoutConstraint.activate(constraints)
                
                graphStack.addArrangedSubview(graphBottom)
                graphStack.addArrangedSubview(graphLabel)
                
                graphStackView.addArrangedSubview(graphStack)
                
                UIView.animate(withDuration: 1.0, animations: {
                    graphBottom.layoutIfNeeded()
                })
            }
            print("SUMTIME 2")
           
            let averageTime = ((Int(sumTime) / count) / 3600)
            print(averageTime)
            averageTimeLabel.text = String(format: "%d"+"h", averageTime)
        }
    }
    
    func setupInfo(label: UILabel, index: Int, trackerInfo : Results<Tracker>) {
        //formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        let startTime = formatter.string(from: trackerInfo[index]["startTime"] as! Date)
        label.text = "\(startTime)"
    }
}
